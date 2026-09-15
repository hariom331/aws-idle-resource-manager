import logging

log = logging.getLogger()
log.setLevel(logging.INFO)


def lambda_handler(event, context):
    log.info("hello world from idle-guard-reaper, event: %s", event)
    return {"message": "hello world"}
