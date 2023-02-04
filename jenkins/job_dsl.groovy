folder("Whanos base images") {
	description("All whanos base images.")
}

folder("Projects") {
	description("All projects in whanos instance.")
}

langs = ["c", "java", "javascript", "python", "befunge"]

langs.each { lang ->
	freeStyleJob("Whanos base images/whanos-$lang") {
		steps {
			shell("docker build /images/$lang -f /images/$lang/Dockerfile.base -t whanos-$lang")
		}
	}
}

freeStyleJob("Whanos base images/Build all base images") {
	publishers {
		downstream(
			langs.collect { lang -> "Whanos base images/whanos-$lang" }
		)
	}
}


freeStyleJob("link-project") {
	parameters {
		stringParam("GIT_URL", null, 'Git https repository url')
		stringParam("DISPLAY_NAME", null, "Job display name")
	}
	steps {
		dsl {
			text('''
				freeStyleJob("Projects/$DISPLAY_NAME") {
					scm {
						git {
							remote {
								name("origin")
								url("$GIT_URL")
							}
						}
					}
					triggers {
						scm("* * * * *")
					}
					wrappers {
						preBuildCleanup()
					}
					steps {
						shell("/jenkins/piepline.sh \\"$DISPLAY_NAME\\"")
					}
				}
			''')
		}
	}
}