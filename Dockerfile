FROM --platform=amd64 jacobneiltaylor/garrysmod

COPY ./files/server.cfg ./cfg
COPY ./files/users.txt ./settings

USER root

RUN \
    --mount=type=secret,id=AWS_ACCESS_KEY_ID \
    --mount=type=secret,id=AWS_SECRET_ACCESS_KEY \
    --mount=type=secret,id=AWS_SESSION_TOKEN \
    AWS_ACCESS_KEY_ID=$(cat /run/secrets/AWS_ACCESS_KEY_ID) \
    AWS_SECRET_ACCESS_KEY=$(cat /run/secrets/AWS_SECRET_ACCESS_KEY) \
    AWS_SESSION_TOKEN=$(cat /run/secrets/AWS_SESSION_TOKEN) \
    load_maps.py s3://fastdl.syd.s3.aws.jacobtaylor.id.au/gmod/maps/ ./maps

RUN --mount=type=secret,id=RCON_PASSWORD echo rcon_password "$(cat /run/secrets/RCON_PASSWORD)" >> ./cfg/rcon.cfg && chown steam:steam ./cfg/rcon.cfg

USER steam

CMD [ "+map", "gm_construct", "+maxplayers", "20", "+host_workshop_collection", "2095965929" ]
