ARG PYTHON_VERSION=3.7.3-alpine3.9

FROM python:${PYTHON_VERSION} as builder

ENV PYTHONUNBUFFERED 1

# build wheels instead of installing
WORKDIR /wheels
COPY requirements.txt .
RUN pip install -U pip && \
    pip wheel -r requirements.txt


FROM python:${PYTHON_VERSION}

# copy built previously wheels archives
COPY --from=builder /wheels /wheels

# use archives from /weels dir
RUN pip install -U pip \
       && pip install -r /wheels/requirements.txt -f /wheels \
       && rm -rf /wheels \
       && rm -rf /root/.cache/pip/*
