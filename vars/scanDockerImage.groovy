def call(String imageName, String imageTag) {
    echo "Scanning Docker image (placeholder for Trivy): ${imageName}:${imageTag}"
    // sh "trivy image ${imageName}:${imageTag}"  // Uncomment if Trivy installed
}

