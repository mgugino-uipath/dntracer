FROM redhat/ubi8
WORKDIR /app
RUN yum install -y dotnet-sdk-6.0 jq
# RUN curl -L -o dotnet-trace https://aka.ms/dotnet-trace/linux-x64 && chmod +x dotnet-trace
RUN dotnet tool install --global dotnet-dump && \
  dotnet tool install --global dotnet-gcdump && \
  dotnet tool install --global dotnet-trace && \
  dotnet tool install --global dotnet-stack && \
  dotnet tool install --global dotnet-counters
RUN curl -L -o containerd.tar.gz https://github.com/containerd/containerd/releases/download/v1.5.7/containerd-1.5.7-linux-amd64.tar.gz \
  && tar xf containerd.tar.gz && rm containerd.tar.gz
CMD [ "/dotnet-trace" ]
