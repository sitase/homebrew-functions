class AzureFunctionsCoreToolsV3Preview < Formula
  desc "Azure Functions Core Tools 3.0"
  homepage "https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/3.0.2245/Azure.Functions.Cli.osx-x64.3.0.2245.zip"
  version "3.0.2245"
  # make sure sha256 is lowercase.
  sha256 "1f2757b249e79c7b6e2dca0c5a04b5cec438147e7db33729cc5bb896f38927bc"
  head "https://github.com/Azure/azure-functions-core-tools"

  bottle :unneeded

  @@telemetry = "\n Telemetry \n --------- \n The Azure Functions Core tools collect usage data in order to help us improve your experience." \
  + "\n The data is anonymous and doesn\'t include any user specific or personal information. The data is collected by Microsoft." \
  + "\n \n You can opt-out of telemetry by setting the FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT environment variable to \'1\' or \'true\' using your favorite shell.\n"

  def install
    prefix.install Dir["*"]
    chmod 0555, prefix/"func"
    chmod 0555, prefix/"gozip"
    bin.install_symlink prefix/"func"
    begin
      FileUtils.touch(prefix/"telemetryDefaultOn.sentinel")
      print @@telemetry
    rescue Exception
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/func")
    system bin/"func", "new", "-l", "C#", "-t", "HttpTrigger", "-n", "confusedDevTest"
    assert_predicate testpath/"confusedDevTest/function.json", :exist?
  end
end
