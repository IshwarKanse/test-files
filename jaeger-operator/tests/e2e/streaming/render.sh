#!/bin/bash

source $(dirname "$0")/../render-utils.sh

is_secured="false"
if [ $IS_OPENSHIFT = true ]; then
    is_secured="true"
fi


###############################################################################
# TEST NAME: streaming-simple
###############################################################################
if [ $SKIP_KAFKA = true ]; then
    skip_test "streaming-simple" "SKIP_KAFKA is true"
else
    start_test "streaming-simple"
    render_install_kafka "my-cluster" "00"
    render_install_elasticsearch "upstream" "03"
    JAEGER_NAME="simple-streaming" $GOMPLATE -f $TEMPLATES_DIR/streaming-jaeger-assert.yaml.template -o ./04-assert.yaml
    render_smoke_test "simple-streaming" "$is_secured" "05"
fi


###############################################################################
# TEST NAME: streaming-with-tls
###############################################################################
if [ $SKIP_KAFKA = true ]; then
    skip_test "streaming-with-tls" "SKIP_KAFKA is true"
else
    start_test "streaming-with-tls"
    render_install_kafka "my-cluster" "00"
    render_install_elasticsearch "upstream" "03"
    render_smoke_test "tls-streaming" "$is_secured" "05"
fi
