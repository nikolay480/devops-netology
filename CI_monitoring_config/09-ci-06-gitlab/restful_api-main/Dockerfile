# This file is a template, and might need editing before it works on your project.

FROM quay.io/centos7/python-38-centos7

WORKDIR /python_api

COPY requirements.txt python-api.py ./ 

RUN pip3 install -r requirements.txt

ENTRYPOINT ["python3", "python-api.py"]

EXPOSE 5290
