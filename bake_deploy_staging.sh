#!/bin/bash
set -ex

uv run unmute/scripts/check_hugging_face_token_not_write.py $HUGGING_FACE_HUB_TOKEN


###########modified##########export DOMAIN=unmute-staging.kyutai.io
export KYUTAI_LLM_MODEL=google/gemma-3-4b-it
export DOCKER_HOST=ssh://root@${DOMAIN}

echo "If you get an connection error, do: ssh root@${DOMAIN}"

docker buildx bake -f ./swarm-deploy.yml --allow=ssh --push
docker stack deploy --with-registry-auth --prune --compose-file ./swarm-deploy.yml llm-wrapper
docker service scale -d llm-wrapper_tts=1 llm-wrapper_llm=1
