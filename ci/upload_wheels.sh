set_upload_vars() {
    echo "IS_PUSH is $IS_PUSH"
    echo "IS_SCHEDULE_DISPATCH is $IS_SCHEDULE_DISPATCH"
    if [[ "$IS_PUSH" == "true" ]]; then
        echo push and tag event
        export TOKEN="$PANDAS_STAGING_UPLOAD_TOKEN"
        export ANACONDA_UPLOAD="true"
    else
        echo non-dispatch event
        export ANACONDA_UPLOAD="false"
    fi
}
upload_wheels() {
    echo ${PWD}
    if [[ ${ANACONDA_UPLOAD} == true ]]; then
        if [ -z ${TOKEN} ]; then
            echo no token set, not uploading
        else
            # sdists are located under dist folder when built through setup.py
            if compgen -G "./dist/*.gz"; then
                echo "Found sdist"
                twine upload -r https://pkgs.dev.azure.com/key-capture-energy/_packaging/kce/pypi/upload/ -u . -p ${TOKEN} ./dist/*.gz
                echo "Uploaded sdist"
            fi
            if compgen -G "./wheelhouse/*.whl"; then
                echo "Found wheel"
                twine upload -r https://pkgs.dev.azure.com/key-capture-energy/_packaging/kce/pypi/upload/ -u . -p ${TOKEN} ./wheelhouse/*.whl
                echo "Uploaded wheel"
            fi
        fi
    fi
}