FROM murvudd/ubuntu-python:latest

RUN apt update && apt upgrade -y
RUN apt install curl -y
RUN apt install mongodb-clients -y
RUN apt install zip -y


RUN pip3 install awscli==1.16.142
RUN pip3 install certifi==2019.3.9
RUN pip3 install chardet==3.0.4
RUN pip3 install colorama==0.3.9
RUN pip3 install idna==2.8
RUN pip3 install pyasn1==0.4.5
RUN pip3 install PyYAML==3.13
RUN pip3 install rsa==3.4.2
RUN pip3 install urllib3==1.24.1
RUN pip3 install virtualenv==16.4.3
RUN pip3 install pymongo
RUN pip3 install azure
RUN pip3 install pandas