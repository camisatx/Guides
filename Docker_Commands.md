# Docker Commands

## Transfer docker data volume to another host

From one remote host to another remote host, connecting to them through SSH.

`ssh <SOURCE_SSH_HOST> 'docker run --rm -v <SOURCE_DATA_VOLUME_NAME>:/from alpine ash -c "cd /from ; tar -cf - . " ' | ssh <TARGET_SSH_HOST> 'docker run --rm -i -v <TARGET_DATA_VOLUME_NAME>:/to alpine ash -c "cd /to ; tar -xpvf - " '`

[Source](https://www.guidodiepen.nl/2016/05/transfer-docker-data-volume-to-another-host/)
