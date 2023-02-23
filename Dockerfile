# custom build of CIVET 2.1.1 with inflate_to_sphere_implicit
FROM docker.io/fnndsc/civet:unofficial

COPY microminc.sh /usr/local/bin/microminc.sh

CMD ["/usr/local/bin/microminc.sh"]
