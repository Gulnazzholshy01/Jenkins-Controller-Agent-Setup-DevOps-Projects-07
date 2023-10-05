import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;

println "--> creating SSH credentials"

domain = Domain.global()
store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

mastersPrivateKey = new BasicSSHUserPrivateKey(
CredentialsScope.GLOBAL,
"jenkins-master",
"jenkins",
new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource('''
PUT PRIVATE KEY
'''),
"",
"Private SSH Key for Master Node"
)

store.addCredentials(domain, mastersPrivateKey)