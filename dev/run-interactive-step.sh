#/bin/bash


usage() {
  cat << EOF
Run a workflow using act.

Usage:
  $0 WORKFLOW_FILE [BRANCH]

This script should be called from the main folder of the repository.

Workflow file should be a GitHub workflow.

If branch is not specified, the script will use the current branch of the repository.
EOF
}

RUNTIME="podman"
ROOTLESS=0

for ARG in "$@"
  do
  case $ARG in
    -h|--help)
    shift
    usage
    exit 0
    ;;
    -d|--docker)
    RUNTIME=docker
    shift
    ;;
    -r|--no-rootless)
    ROOTLESS=1
    shift
    ;;
  esac
done

if [[ "$ROOTLESS" -eq 0 ]] && [[ "$RUNTIME" == "podman" ]]
then
  PODMAN_SOCKET=$XDG_RUNTIME_DIR/podman/podman.sock
  export DOCKER_HOST=unix://$PODMAN_SOCKET
  ACT_CONTAINER_SOCKET="--container-daemon-socket $PODMAN_SOCKET"
fi

if [[ "$#" -lt 2 ]]
then
  echo "Error: No workflow file and job step were given!"
  echo
  usage
  exit 1
fi

WORKFLOW="$1"

if [[ ! -f "$WORKFLOW" ]]
then
  echo "Error: Workflow file \"$WORKFLOW\" does not exist!"
  echo
  usage
  exit 1
fi

JOB="$2"

YQ_COMMAND=`command -v yq`
if [[ ! -f "$YQ_COMMAND" ]]
then
  echo "Error: yq is missing"
  echo
  exit 1
fi

echo "Running job \"$JOB\" from workflow \"$WORKFLOW\""


IMAGE=`yq ".jobs.${JOB}.container.image" ${WORKFLOW}`
VOLUMES=`yq ".jobs.${JOB}.container.volumes[]" ${WORKFLOW} | xargs -I {} echo -n ' -v {} '`

if [[ "${IMAGE}" == "null" ]]
then
  echo "Error: No image found for job step ${JOB} from workflow ${WORKFLOW}"
  echo
  exit 1
fi

$RUNTIME run $VOLUMES --entrypoint=/bin/bash -it --rm ${IMAGE}
