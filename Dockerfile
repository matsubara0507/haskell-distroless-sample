FROM fpco/stack-build-small:latest as stack-build

FROM gcr.io/distroless/base-debian11:latest
COPY --from=stack-build /lib/x86_64-linux-gnu/libz.so.* /lib/x86_64-linux-gnu/
COPY --from=stack-build /usr/lib/x86_64-linux-gnu/libgmp.so.* /usr/lib/x86_64-linux-gnu/
ARG local_bin_path
COPY ${local_bin_path} /usr/local/bin
ENTRYPOINT ["/usr/local/bin/sample"]
