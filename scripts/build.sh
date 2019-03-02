#!/bin/bash

EXECUTEDIR=$(pwd)
DOCKERFILE=""
DO_BUILD=false
DO_PUSH=false
DO_FORCED=false

ENVFILE=$EXECUTEDIR/.env
if [ -f $ENVFILE ]; then
    export $(grep -v '^#' $ENVFILE | xargs)
fi

if [ "$DOCKER_USERNAME" = "" ]; then
    DOCKER_USERNAME=bertoost
fi

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -f)
            DOCKERFILE=$1
            ;;
        --build)
            DO_BUILD=true
            ;;
        --push)
            DO_PUSH=true
            ;;
        --force)
            DO_FORCED=true
            ;;
        *)
            if [[ "$PARAM" == *"Dockerfile"* ]] || [ -d "$PARAM" ]; then
                DOCKERFILE=$PARAM
            else
                echo "ERROR: unknown parameter \"$PARAM\""
                exit 1
            fi
            ;;
    esac
    shift
done

if [ "$DOCKERFILE" = "" ]; then
  echo ""
  echo "No Dockerfile or path given! [required]"
  exit 1
fi

if [ "$DO_BUILD" = false ] && [ "$DO_PUSH" = false ]; then
  echo ""
  echo "At least one action is required! (--build | --push)"
  exit 1
fi

# !! DOCKERFILE PARSER FUNCTION !!
parse_dockerfile()
{
    DOCKERFILE=$1
    SLASHCOUNT=$(awk -F"/" '{print NF-1}' <<< "${DOCKERFILE}")

    DIR=$(dirname "${DOCKERFILE}")
    cd $DIR

    DOCKERFILE_RELATIVE=$(basename "${DOCKERFILE}")

    # determine the vendor/image name
    IMAGENAME=$(cut -d/ -f2 <<< "${DOCKERFILE}")
    IMAGENAME="$DOCKER_USERNAME/$IMAGENAME"

    # read version from the Docker file
    FROMVERSION=$(head -n 1 ${DOCKERFILE_RELATIVE})
    FROMVERSION=$(cut -d ":" -f 2 <<< "$FROMVERSION")
    FROMVERSION_LONG=$(sed 's/-.*//' <<< "$FROMVERSION") # 1.2.3
    FROMVERSION_MEDIUM=$(sed 's/\(.*\)\..*/\1/' <<< "$FROMVERSION_LONG") # 1.2
    FROMVERSION_SHORT=$(sed 's/\(.*\)\..*/\1/' <<< "$FROMVERSION_MEDIUM") # 1

    # determine the tag specifics (fpm-development etc.)
    TYPE=$(cut -d/ -f$((${SLASHCOUNT}+1)) <<< "${DOCKERFILE}")
    TYPE=$(echo ${TYPE} | sed -e "s/Dockerfile\.//g")
    TYPE=$(echo ${TYPE} | sed -e "s/\./-/g")
    if [[ "${TYPE}" = "Dockerfile" ]]; then
        TYPE="latest"
    fi

    # create first tag (full)
    TAG_LONG="${IMAGENAME}:${FROMVERSION_LONG}-${TYPE}"
    TAG_MEDIUM="${IMAGENAME}:${FROMVERSION_MEDIUM}-${TYPE}"
    TAG_SHORT="${IMAGENAME}:${FROMVERSION_SHORT}-${TYPE}"

    echo "Preparing ${TAG_LONG} ..."

    if [[ "$DO_BUILD" = true ]]; then

        # pull before build to grab some cache
        docker pull "${IMAGENAME}:${TAG}"

        # create a working copy when docker-username is set
        # since Dockerfiles can't have environment variables in the FROM statement
        if [[ "${DOCKER_USERNAME}" != "bertoost" ]]; then
            cp ${DOCKERFILE_RELATIVE} ${DOCKERFILE_RELATIVE}.working
            sed -i "s/FROM bertoost/FROM ${DOCKER_USERNAME}/g" ${DOCKERFILE_RELATIVE}.working

            # build working file
            docker build -f "${DOCKERFILE_RELATIVE}.working" -t "${TAG_LONG}" -t "${TAG_MEDIUM}" -t "${TAG_SHORT}" .

            rm -f ${DOCKERFILE_RELATIVE}.working;
        else
            # build docker file
            docker build -f "${DOCKERFILE_RELATIVE}" -t "${TAG_LONG}" -t "${TAG_MEDIUM}" -t "${TAG_SHORT}" .
        fi
    fi

    if [[ "$DO_PUSH" = true ]]; then
        docker push "${TAG_LONG}"
        docker push "${TAG_MEDIUM}"
        docker push "${TAG_SHORT}"
    fi

    cd ${EXECUTEDIR}

    echo ""
    echo "------------------------"
    echo ""
}

# When DOCKERFILE is a directory, scan it for all Dockerfile's
if [ -d $DOCKERFILE ]; then

    FILES="$DOCKERFILE/*"
    for FILE in $FILES
    do
        FILEBASE=$(basename $FILE)
        if [[ $FILEBASE == Dockerfile* ]]; then

            if [ "$DO_FORCED" = true ]; then
                parse_dockerfile $FILE
            else
                read -p "Do you want to parse ${FILEBASE} (Y/n)?" COND
                if [ "$COND" = "y" ] || [ "$COND" = "Y" ] || [ "$COND" = "" ]; then
                    parse_dockerfile $FILE
                fi
            fi
        fi
    done
else
    if [ ! -f $DOCKERFILE ]; then
        echo "DockerFile not found!"
        echo 'Select a correct Dockerfile to build'
        exit 0
    fi

    parse_dockerfile $DOCKERFILE
fi