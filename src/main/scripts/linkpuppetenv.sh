#!/bin/sh

#################################
# Links puppet module classes with
# The set environments
##################################

envs="dev prod qa"
dirname=/var/lib/puppet/modules
envdir=/var/lib/puppet/environments
fdir=$dirname/*
for f in $fdir
do
   # echo $f
   tempf=$f
   module=`echo $tempf | cut -d'/' -f6`
   moduledir="$dirname/$module/manifests"

   for ff in $moduledir/*
   do
        fname=`echo $ff | cut -d'/' -f8`
        for environ in $envs
        # "dev" "prod" "qa"
        do
                fenvdir="$envdir/$environ/modules/$module/manifests"
                if [ -d "$fenvdir/" ]; then
                        if [ ! -f "$fenvdir/$fname" ]; then
                            echo "doesn't have file: $fenvdir/$fname from $moduledir/$fname "
                            ln -s "$moduledir/$fname" "$fenvdir/$fname"
                        fi
                fi
        done
   done
done

