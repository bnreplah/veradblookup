#!/bin/bash

versioninfo="v2.0.1"
verbose=true
clearprompt=true

function versioninfo {
    echo "--------------------------------------------"
    echo "Version:" $versioninfo
    echo "Author: Ben Halpern - Veracode CSE "
    echo "License information for this tool: https://github.com/bnreplah/Veracode-scripts/blob/main/LICENSE"
    echo "Veracode Databse Lookup Wrapper $versioninfo"
}



function logo {

    echo "============================================"
    echo "====00000000000000==========11111111111====="
    echo "====000========000===========1111111111====="
    echo "====000========000===============111111====="
    echo "====000========000===============111111====="
    echo "====000========000===============111111====="
    echo "====00000000000000============11111111111==="
    echo "============================================"
    echo "      Veracode Database Lookup Wrapper"
    echo "============================================"
    versioninfo
}


function help {
    srcclr --version
    logo
    echo "veradbLookup -h : Help";
    echo "--------------------------------------------"
    echo "Modes"
    echo "~~~~~~~~~~~~~~~~~~~~~~~"
    echo "-p : Prompt mode - enter an interactive prompt"
    echo "-i : Inline mode - follow this parameter by the inline properties to search the database with"
    echo ""
    echo "veradbLookup -p "
    echo "veradblookup -i --type <Package Manager> --namespace <Module/groupId>  --version <Library Version>";
    echo "veradblookup -i --type maven --namespace <Module/GroupId> --artifactid <ArtifactID> --version <Library Version>";
    echo ""
    echo "Search Parameters:"
    echo "~~~~~~~~~~~~~~~~~~~~~~~"
    echo "-namespace  : Module name or groupId"
    echo "              The primary library name in all cases except for type maven, where the first coordinate (namespace parameter) identifies the groupId in Maven nomenclature."
    echo "              The case sensitivity of the namespace depends on whether the underlying registry distinguishes packages by case."
    echo "              PyPI, for example, is not case-sensitive while Maven is case-sensitive. In the case of Go libraries, the namespace should be the domain and top-level package name."
    echo "              For example: github.com/docker/docker"
    echo "              [https://docs.veracode.com/r/Veracode_SCA_Agent_Commands]"
    echo ""
    echo "-artifactid : Artifact ID"
    echo "              optional, but required for Maven. If you include the type maven, this specifies the artifactId of the library to lookup."
    echo ""
    echo "-type       : Package Manager or Type"
    echo "              The type of registry that contains the library one is going to specify using"
    echo "              Acceptable options are:"
    echo "              gem       | to identify a Ruby Gem dependency as one would find on rubygems.org"
    echo "              maven     | to identify a Maven dependency as one would find on repo.maven.apache.org"
    echo "              npm       | to identify a JavaScript dependency as one would find on npmjs.com"
    echo "              pypi      | to identify a Python dependency as one would find on pypi.python.org"
    echo "              cocoapods | to identify a CocoaPods dependency as one would find on cocoapods.org"
    echo "              go        | to identify a Go dependency as one would find on the common Go repositories such as github.com, bitbucket.org, gopkg.in, golang.org"
    echo "              packagist | to identify a PHP dependency as one would find on packgist.org"
    echo "              nuget     | to identify a .NET dependency as one would find on nuget.org "
    echo "              [https://docs.veracode.com/r/Veracode_SCA_Agent_Commands]"
    echo ""
    echo "-platform   : Platform [Under development]"
    echo "              optional. Specify the target platform of a library located in the registry, such as freebsd or py3, depending on the package and registry used."
    echo ""
    echo "-version    : Version"
    echo "              The version number, as specified in the registry that you identify with the --type parameter, of the library to lookup. For Go, the version can be:"
    echo "                 A release tag in the library repository"
    echo "                 A prefix of a commit hash of at least seven digits"
    echo "                 In v0.0.0-{datetime}-{hash} format"
    echo "              [https://docs.veracode.com/r/Veracode_SCA_Agent_Commands]"
    echo ""
    echo "PURL CPE Lookup [Experimental]"
    echo "--------------------------------------------"
    echo "veradblookup -r <PURL>";
#    echo "veradblookup -r <CPE> <Package Manager/Type> [Experimental]";
#    echo "veradblookup -r <ref> [Experimental]";
#    echo ""
#    echo "SBOM Functions [Experimental]"
#    echo "---------------------------------------------"
#    echo "veradblookup -s <SBOM File>       : Parse SBOM file and produce report to the stdout"
#    echo "veradblookup -s <SBOM File> -o <outputfile>.txt   : Parse SBOM file and produce report to output file"
#    echo "veradblookup -s <SBOM File> -oS <Out SBOM File>   : Parse SBOM file and populate VEX data"
#    echo "veradblookup -s <SBOM File> <Second SBOM File>    : Combine 2 SBOMS"
#    echo "veradblookup -s <SBOM File> --generate-full       : Generates a Full SBOM based of the component information provided from the platform" 


}   

#################################################################################
# If no parameters are passed
#################################################################################
echo "Veracode DB Look Up Tool"
if [ -z $1 ]; then
    help
fi # end if block

#################################################################################
# if -h or --help or help is passed as the first argument
#################################################################################
if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
    echo "Showing help"
    help
# end if block
#################################################################################
# Prompt Mode
#################################################################################    
elif [ "$1" == "-p" ] || [ "$1" == "--prompt" ]; then
    logo
    echo "--------------------------------------------------------------------  Entering Interactive mode -----------------------------------------------------------------------------------"
    echo "Enter the Type / Package Manager. The following are the acceptable options:  [gem, maven, npm, pypi, cocoapods, go, packagist, nuget] "
    echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    echo "Your Input [Type]:> "
    read collector
    echo "Read " $collector
    if [ "$clearprompt" == "true" ]; then
        clear
    fi # end if block
    echo "Enter the primary library or groupId. This is the primary library name in all cases except for type maven, where the first coordinate identifies the groupId in Maven nomenclature."
    echo "The case sensitivity of the namespace depends on whether the underlying registry distinguishes packages by case."
    echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    echo "Your Input [Primary Library / groupId / namespace]:> "
    read namespace
    echo "Read " $namespace
    #clear
    if [ "$clearprompt" == "true" ]; then
         clear
    fi # end if block

    if [ "$collector" == "maven" ]; then
        echo "Enter the maven artifactId. This specifies the artifactId of the library to lookup. "
        echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        echo "Your Input [Artifact ID]:> "
        read artifactid
        echo "Read " $artifactid
    fi # end if block
    echo "[Optional] Enter the platform, otherwise press enter: "
    echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    echo "Your input [Platform]:> "
    read platform
    echo "Read " $platform
    #clear
    if [ "$clearprompt" == "true" ]; then
         clear
    fi # end if block
    echo "Enter the library version. The version number, as specified in the registry that you identify with the type, of the library to lookup. "
    echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    echo "Your Input [Version]:>"
    read version
    echo "Read " $version
    if [ "$clearprompt" == "true" ]; then
         clear
    fi # end if block

    if [ "$collector" == "maven" ]; then
        echo "Maven detected "
        echo "-----------------------------------------------------------------------------"
        echo "GroupID or Module: $namespace "
        echo "ArtifactID: $artifactid"
        echo "Type: $collector"
        echo "Version: $version"
 #       if [  -n $platform ] && [ "$platform" != " "  && "$platform" != "\n"]; then
 #           echo "srcclr lookup --coord1 "$namespace" --coord2 "$artifactid" --type "$collector" --platform "$platform" --version "$version" --json"
 #           srcclr lookup --coord1 $namespace --coord2 $artifactid --type $collector --platform $platform --version $version --json
 #       else
           echo "srcclr lookup --type="$collector" --coord1="$namespace" --coord2="$artifactid"  --version="$version" --json"
           srcclr lookup --type=$collector --coord1=$namespace --coord2=$artifactid --version=$version --json
 #       fi
    # end if block
    elif [ "$collector" == "gem" || "$collector" == "npm" || "$collector" == "pypi" || "$collector" == "cocoapods" || "$collector" == "go" || "$collector" == "packagist" ]; then
        echo "$collector detected "
        echo "-----------------------------------------------------------------------------"
        echo "GroupID or Module: $namespace "
        echo "Type: $collector"
        echo "Version: $version"

#        if [ -n $platform ]; then
#           echo "srcclr lookup --coord1 "$namespace" --coord2 "$artifactid" --type "$collector" --version "$version" --json"
#           srcclr lookup --json --coord1 $namespace --type $collector --platform $platform --version $version
#        else
           echo "srcclr lookup --json --coord1="$namespace" --type="$collector" --version=" $version
           srcclr lookup --json --type=$collector --coord1=$namespace --version=$version
#        fi
    # end elif block
    else
        echo "[Error] Incorrect Syntax"
        help
    fi    # end else elif if block

#################################################################################
# Inline Mode
#################################################################################
elif [ "$1" == "-i" ] || [ "$1" == "--inline" ]; then
    shift 1
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --type)
                type="$2"
                if [ "$verbose" == "true" ]; then
                        echo "Type: $type"
                fi
                shift 2
                ;;
            --namespace)
                namespace="$2"
                if [ "$verbose" == "true" ]; then
                        echo "Namespace: $namespace"
                fi
                shift 2
                ;;
            --artifactid)
                artifactid="$2"
                if [ "$verbose" == "true" ]; then
                        echo "ArtifactId: $artifactid"
                fi
                shift 2
                ;;
            --platform)
                platform="$2"
                if [ "$verbose" == "true" ]; then
                        echo "Platform: $platform"
                fi
                shift 2
                ;;
            --version)
                version="$2"
                if [ "$verbose" == "true" ]; then
                        echo "Version: $version"
                fi
                shift 2
                ;;
            *)
                echo "Unknown argument: $2"
                help
                exit 1
                ;;
        esac
    done # end case block

    if [ -z $type ]  && [ -z $namespace ] && [ -z $version  ]; then
        echo "[ERROR] Please provide a parameter";
        help;
    # end if block
    else
        if [ -n $type ] && [ "$type" == "maven" ]; then
            if [ -n $artifactid ]; then
#                if [ -n $platform ] && [ "$platform" != " " ]; then
#                   echo "srcclr lookup --type $type --coord1 $namespace --coord2 $artifactid --platform $platform --version $version --json";
#                    srcclr lookup --type $type --coord1 $namespace --coord2 $artifactid --version $version --platform $platform --json;
#                else
                    echo "srcclr lookup --type $type --coord1 $namespace --coord2 $artifactid --version $version --json";
                    srcclr lookup --type $type --coord1 $namespace --coord2 $artifactid --version $version --json;
#                fi
            # end if block
            else
                echo "[ERROR] Artifact ID is required with the type maven"
                help
            fi # end else if block
        # end if block
        elif [ -n $type ] && [ "$type" == "gem" || "$type" == "npm" || "$type" == "pypi" || "$type" == "cocoapods" || "$type" == "go" || "$type" == "packagist" ]; then
            if [ -n $artifactid ]; then
#                if [ -n $platform ]  && [ "$platform" != " " ]; then
#                   echo "srcclr lookup --type $type --coord1 $namespace --coord2 $artifactid --platform $platform --version $version --json";
#                    srcclr lookup --type $type --coord1 $namespace --coord2 $artifactid --version $version --platform $platform --json;
#                else
                    echo "srcclr lookup --type $type --coord1 $namespace --coord2 $artifactid --version $version --json";
                    srcclr lookup --type $type --coord1 $namespace --coord2 $artifactid --version $version --json;
#                fi
            # end if block
            else
                echo "srcclr lookup --type $type --coord1 $namespace --version $version --json";
                srcclr lookup --type $type --coord1 $namespace --version $version --json;
            fi    # end else if block
        # end elif block
        else

            echo "[ERROR]: provide a supported type";
        fi # end else elif if block
    fi # end else if block
#################################################################################
# Reference Mode
#################################################################################
elif [ "$1" == "-r" ] || [ "$1" == "--ref" ]; then
        if [ -z $2 ]; then
            while [ -z $ref ]; do
                    echo "Please enter a parameter"
                    # exit condition:
                    read ref
                    
            done # end while loop
        # end if block
        else
            ref=$2
        fi # end else if block

       
        echo "ref lookup mode"

        # Could also use just pass verbose and leave blank to minimize
        # if ref is not null and verbose is true
        # Check to see if there is an argument is passed
        if [ -n $ref ] && [ "$verbose" == "true" ]; then
                echo "Input recieved";
        fi # end if block

        # If Debug is set/equal to true
        if $DEBUG; then
            echo $ref_header
            if [ "$ref_header" == "cpe" ]; then
                echo "CPE"
            elif [ "$ref_header" == "pkg" ]; then
                echo "PURL"
            else
                echo "ref"
            fi # end else elif if block
        fi # end if block
        
        # Checkes to see the first values of the reference coordinate format
        # if the first field is pkg then it is the purl signature
        if  [ $( echo $ref | cut -d ':' -f1 ) == 'pkg' ]
        then
           #################################################################################
           # PURL Mode
           #################################################################################
            
            echo "PURL"
            type=$(echo $ref | cut -d ':' -f2 | cut -d '/' -f1) 
            namespace=$( echo $ref | cut -d ':' -f2 | cut -d '/' -f2)
            name=$( echo $ref | cut -d ':' -f2 | cut -d '/' -f3 | cut -d '@' -f1)
            version=$( echo $ref | cut -d ':' -f2 | cut -d '/' -f3 | cut -d '@' -f2)
            vendor=$(echo $ref | cut -d ':' -f2 | cut -d '/' -f2 | cut -d '.' -f2)	
            echo "cpe:2.3:a:"$vendor":"$name":"$version":*:*:*:*:*:*:*"
            echo "cpa:/a:"$vendor":"$name":"$version  
            #srcclr lookup --coord1 $namespace --coord2 $name --type $type --version $version --json
            if  [[ $( echo $ref | cut -d ':' -f1 ) == 'pkg' ]]; then
                echo "PURL identified "
                echo "-----------------------------------------------------------------------------"
                echo $(echo $ref | cut -d ':' -f2 | cut -d '/' -f1)
                if [ "$(echo $ref | cut -d ':' -f2 | cut -d '/' -f1)" == "maven" ]
                then
                        echo "Maven detected"
                        echo "-----------------------------------------------------------------------------"
                        echo "GroupID or Module: $( echo $ref | cut -d ':' -f2 | cut -d '/' -f2) "
                        echo "ArtifactID: $( echo $ref | cut -d ':' -f2 | cut -d '/' -f3 | cut -d '@' -f1)"
                        echo "Type: $(echo $ref | cut -d ':' -f2 | cut -d '/' -f1)"
                        echo "Version: $( echo $ref |  cut -d '@' -f2)"

                        srcclr lookup --coord1 $( echo $ref | cut -d ':' -f2 | cut -d '/' -f2) --coord2 $( echo $ref | cut -d ':' -f2 | cut -d '/' -f3 | cut -d '@' -f1) --type $(echo $ref | cut -d ':' -f2 | cut -d '/' -f1) --version $( echo $ref |  cut -d '@' -f2) --json=./SCALookup-Out.json
                # end if block
                else
                        echo "===== $(echo $ref | cut -d ':' -f2 | cut -d '/' -f1) detected ===== "
                        echo "GroupID or Module: $( echo $ref | cut -d ':' -f2 | cut -d '/' -f2 | cut -d '@' -f1) "
                        echo "Type: $(echo $ref | cut -d ':' -f2 | cut -d '/' -f1)"
                        echo "Version: $( echo $ref | cut -d '@' -f2)"

                        srcclr lookup --json --coord1 $( echo $ref | cut -d ':' -f2 | cut -d '/' -f2 | cut -d '@' -f1) --type  $(echo $ref | cut -d ':' -f2 | cut -d '/' -f1) --version $( echo $ref | cut -d '@' -f2)
                fi # end else if block
            fi # end if block
        # end if block
        # if the first portion of the reference is cpe then it is a cpe signature
        elif [ $( echo $ref | cut -d ':' -f1 ) == "cpe" ]; then
           #################################################################################
           # CPE Mode
           #################################################################################
        
            type=$3
            echo "CPE"
            namespace=$(echo $ref | cut -d ':' -f4)
            name=$(echo $ref | cut -d ':' -f5)
            version=$(echo $ref |cut -d ':' -f6)
            srcclr lookup --coord1 $namespace --coord2 $name --type $type --version $version --json        
        # end ELIF
        # Otherwise it is a generic ref type
        # Other additional ref types can be added as additional elif statements here
        else

            #################################################################################
            # REF Coordinate Mode
            #################################################################################
            echo "Attempting to look up the reference coordinates"
            echo "Type: $(echo $ref | cut -d ':' -f1 )"
            echo "GroupID or Module: $( echo $ref | cut -d ':' -f2 )"
            if [ "$(echo $ref | cut -d ':' -f1 )" == "maven" ]; then
                echo "Artifact Id: $( echo $ref | cut -d ':' -f3 )" 
                echo "Version: $( echo $ref | cut -d ':' -f4)"
            # end if block
            else 
                echo "Version: $( echo $ref | cut -d ':' -f3)"
            fi # end else if block
        fi # end else if block
#################################################################################
# search
#################################################################################
elif [ "$1" == "-q" ]; then
    curl "https://api.sourceclear.com/catalog/search?q=$2"
        
fi
