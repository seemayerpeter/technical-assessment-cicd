FROM alpine:latest
RUN apk add --no-cache bash
RUN apk add --no-cache curl
RUN apk add --no-cache jq
COPY get_params.sh /get_params.sh
RUN chmod +x ./get_params.sh
CMD ["./get_params.sh"]
