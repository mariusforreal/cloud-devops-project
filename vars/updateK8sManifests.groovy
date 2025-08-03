def call(String imageName, String imageTag, String manifestDir = 'k8s') {
    def filePath = "${manifestDir}/deployment.yaml"
    def content = readFile(filePath)

    // استخلاص التاج الحالي من المانيفست
    def currentTag = content.find(/image:\s+\S+:(\S+)/) { full, tag -> tag }

    if (currentTag == imageTag) {
        echo "✅ Kubernetes manifest is already using image tag: ${imageTag}. Skipping update."
        return
    }

    // تعديل التاج
    def newContent = content.replaceAll(/(image:\s+\S+:)(\S+)/, "\$1${imageTag}")
    writeFile file: filePath, text: newContent

    echo "🛠️ Updated image tag in Kubernetes manifest to: ${imageTag}"
}
