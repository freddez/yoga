
all :
	@echo "usage : make [ install | update ]"
	@echo "	update : update du repertoire cvs par rapport a la prod"
	@echo "	install : mise en prod du repertoire cvs"

# update du repertoire cvs par rapport a la prod
update : rights
	@echo "updating to be implemented"

# mise en prod du repertoire cvs
install : rights
	@echo "installing ..."
	@(for right in `cat rights` ; \
	  do \
		file=`echo $${right} | awk -F';' '{ print $$1 }'` ; \
		owner=`echo $${right} | awk -F';' '{ print $$2 }'` ; \
		group=`echo $${right} | awk -F';' '{ print $$3 }'` ; \
		uright=`echo $${right} | awk -F';' '{ print $$4 }'` ; \
		gright=`echo $${right} | awk -F';' '{ print $$5 }'` ; \
		oright=`echo $${right} | awk -F';' '{ print $$6 }'` ; \
		if [ -d src/$${file} ] ; \
		then \
			mkdir -p /$${file} ; \
		else \
			diff -q src/$${file} /$${file} > /dev/null 2>&1 ; \
			ERR=$$? ; \
			if [ $${ERR} -ne 0 ] ; \
			then \
				if [ $${ERR} -eq 1 ] ; \
				then \
					echo "saving old file in /$${file}.old" ; \
					cp -f /$${file} /$${file}.old ; \
				fi ; \
				cp -f src/$${file} /$${file} ; \
			fi ; \
		fi ; \
		chown $${owner}.$${group} /$${file} ; \
		chmod 000 /$${file} ; \
		l=$${#uright} ; \
		if [ $$l -ne 0 ] ; \
		then \
			exec_bit=`echo $${uright} | cut -c $$l` ; \
			if [ "$${exec_bit}" = "s" ] ; \
			then \
				chmod u+x /$${file} ; \
			fi ; \
		fi ; \
		chmod u+$${uright} /$${file} ; \
		l=$${#gright} ; \
		if [ $$l -ne 0 ] ; \
		then \
			exec_bit=`echo $${gright} | cut -c $$l` ; \
			if [ "$${exec_bit}" = "s" ] ; \
			then \
				chmod g+x /$${file} ; \
			fi ; \
		fi ; \
		chmod g+$${gright} /$${file} ; \
		l=$${#oright} ; \
		if [ $$l -ne 0 ] ; \
		then \
			exec_bit=`echo $${oright} | cut -c $$l` ; \
			if [ "$${exec_bit}" = "s" ] ; \
			then \
				chmod o+x /$${file} ; \
			fi ; \
		fi ; \
		chmod o+$${oright} /$${file} ; \
	  done)

clean :
	@echo "cleaning ..."
	@find . -name '*~' -exec rm -f {} \;

rights : files
	@echo "getting rights ..."
	@rm -f $@
	@(for file in `cat files` ; \
	  do \
		right=`ls -ldL "/$${file}"` ; \
		owner=`echo "$$right" | awk '{ print $$3 }'` ; \
		group=`echo "$$right" | awk '{ print $$4 }'` ; \
		uright=`echo "$$right" | cut -c2-4 | sed 's/-//g'` ; \
		gright=`echo "$$right" | cut -c5-7 | sed 's/-//g'` ; \
		oright=`echo "$$right" | cut -c8-10 | sed 's/-//g'` ; \
		echo "$${file};$${owner};$${group};$${uright};$${gright};$${oright};" >> $@ ; \
	  done)

files : clean
	@echo "getting files ..."
	@cd src;find . | grep -v CVS > ../$@
