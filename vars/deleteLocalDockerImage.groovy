def call(String imageName, String imageTag) {
    echo "Deleting local Docker image: ${imageName}:${imageTag}"
    sh "docker rmi ${imageName}:${imageTag} || true"
}

