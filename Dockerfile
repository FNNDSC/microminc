# custom build of CIVET 2.1.1 with inflate_to_sphere_implicit
FROM docker.io/fnndsc/civet:unofficial

RUN apt-get update \
    && apt-get install -y binutils file

COPY microminc.sh /usr/local/bin/microminc.sh

CMD ["/usr/local/bin/microminc.sh"]
