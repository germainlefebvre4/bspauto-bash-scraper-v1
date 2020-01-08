FROM python:3-alpine as base

ENV PYROOT /pyroot
ENV PYTHONUSERBASE $PYROOT

RUN apk update && \
    apk add py-pip

COPY Pipfile* .
RUN PIP_USER=1 PIP_IGNORE_INSTALLED=1 pipenv install --system --deploy --ignore-pipfile


FROM base

COPY --from=builder $PYROOT/lib/ $PYROOT/lib/
COPY flight-selenium.py .

CMD ["python3", "main.py"]
