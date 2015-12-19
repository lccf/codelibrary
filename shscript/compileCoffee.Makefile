coffeeBaseDir=coffee/
coffeeDir=$(abspath $(coffeeBaseDir))
jsBaseDir=js/
jsDir=$(abspath $(jsBaseDir))
 
jsFile=$(shell find $(coffeeBaseDir) -type f -name *.coffee | sed 's@^$(coffeeBaseDir)@$(jsDir)/@g' | sed 's@\.coffee$$@\.js@g')
 
jsDeploy: $(jsFile)
 
$(jsDir)/%.js: $(coffeeDir)/%.coffee
    @mkdir -p `sed 's@/[^/]\+$$@/@g' <<< '$@'`
    coffee -bp $< > $@
 
test:
    @echo $(jsFile)
 
clean:
    @rm js -fr
    @echo 'clean success!'
