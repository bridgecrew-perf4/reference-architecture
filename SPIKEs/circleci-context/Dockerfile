FROM alpine
RUN apk update \
  && apk upgrade \
  && apk add --update --no-cache \
    curl \
    bash \
    python3 \
    py3-pip \
  && ln -sf python3 /usr/bin/python \
  && rm -rf /var/cache/apk/*
RUN curl -fLSs https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/master/install.sh | bash
RUN pip install boto3
COPY ./entrypoint /usr/bin/entrypoint
RUN chmod 555 /usr/bin/entrypoint
ENTRYPOINT ["entrypoint"]
WORKDIR /work
COPY ./main.py ./module1.py .

