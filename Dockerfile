FROM python:3.9-alpine3.13
LABEL maintainer="swarnim"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmpo/requirements.txt
COPY ./requirements.dev.txt /tmpo/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client &&\
    apk add --update --no-cache --virtual .tmp-build-deps\
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmpo/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmpo/requirements.dev.txt ; \
    fi && \
    rm -rf /tmpo && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user



ENV PATH="/py/bin:$PATH"

USER django-user