### MODULE.bazel

```python
module(
    name = "fitness_tracker",
    version = "1.0.0",
)

bazel_dep(name = "rules_python", version = "0.19.1")
bazel_dep(name = "com_github_grpc_grpc", version = "1.41.0")
bazel_dep(name = "rules_nodejs", version = "4.5.1")
bazel_dep(name = "build_bazel_rules_apple", version = "0.35.0")

# Python dependencies
python.pip_import(
    name = "requirements",
    requirements = "//backend:requirements.txt",
)

# gRPC and Protobuf dependencies
grpc_grpc_deps()
protobuf_deps()
```

### Project Structure

Your project structure remains the same as described earlier:

```
fitness-tracker/
├── backend/
│   ├── src/
│   │   ├── main.py
│   │   ├── auth.py
│   │   ├── profile.py
│   │   ├── BUILD
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── BUILD
├── mobile/
│   ├── ios/
│   │   ├── FitnessTracker/
│   │   │   ├── ContentView.swift
│   │   │   ├── FitnessTrackerApp.swift
│   │   │   ├── BUILD
│   │   ├── BUILD
│   ├── BUILD
├── proto/
│   ├── service.proto
│   ├── BUILD
├── web/
│   ├── src/
│   │   ├── App.js
│   │   ├── index.js
│   │   ├── BUILD
│   ├── BUILD
├── MODULE.bazel
```

### BUILD Files

#### backend/proto/BUILD

```python
load("@rules_python//python:defs.bzl", "py_library")
load("@com_github_grpc_grpc//bazel:grpc_python.bzl", "py_grpc_library")

py_grpc_library(
    name = "service_proto",
    srcs = ["service.proto"],
    deps = [
        "@com_github_grpc_grpc//src/python/grpcio",
        "@com_github_grpc_grpc//src/python/grpcio-tools",
    ],
)
```

#### backend/src/BUILD

```python
py_library(
    name = "backend_lib",
    srcs = ["main.py", "auth.py", "profile.py"],
    deps = [
        "//backend/proto:service_proto",
        "@pypi__firebase_admin//:firebase_admin",
        "@pypi__fastapi//:fastapi",
    ],
)

py_binary(
    name = "backend",
    srcs = ["main.py"],
    deps = [":backend_lib"],
)
```

#### backend/Dockerfile

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY src/ .

CMD ["python", "main.py"]
```

#### backend/requirements.txt

```
firebase-admin
fastapi
grpcio
grpcio-tools
google-cloud-firestore
```

#### mobile/ios/FitnessTracker/BUILD

```python
# iOS specific build rules
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")

ios_application(
    name = "FitnessTracker",
    srcs = glob(["**/*.swift"]),
    bundle_id = "com.example.fitnesstracker",
    families = ["iphone", "ipad"],
    infoplists = ["Info.plist"],
    minimum_os_version = "12.0",
)
```

#### mobile/BUILD

```python
filegroup(
    name = "mobile",
    srcs = glob(["ios/FitnessTracker/**"]),
)
```

#### web/src/BUILD

```python
filegroup(
    name = "srcs",
    srcs = glob(["**/*.js"]),
)
```

#### web/BUILD

```python
load("@npm_bazel_typescript//:index.bzl", "ts_library")

ts_library(
    name = "web",
    srcs = ["src/index.js", "src/App.js"],
    deps = ["@npm//react", "@npm//react-dom"],
)
```

### Building and Deploying

#### Backend

To build the backend with Bazel:

```bash
bazel build //backend/src:backend
```

To deploy the backend to Google Cloud Run:

```bash
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/backend
gcloud run deploy backend --image gcr.io/YOUR_PROJECT_ID/backend --platform managed
```

#### Mobile (iOS)

To build the iOS app with Bazel:

```bash
bazel build //mobile/ios/FitnessTracker:FitnessTracker
```

#### Web

To build the web app with Bazel:

```bash
bazel build //web/src:srcs
```
