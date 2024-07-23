FROM golang:1.22.5 as base

WORKDIR /app 

COPY go.mod ./

RUN go mod download

COPY . .

RUN go build -o main .

#######################################################
# Reduce the image size using multi-stage builds

FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=base /app/main .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]