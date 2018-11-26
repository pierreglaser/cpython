PREVIOUS_HEAD=$(git rev-parse --abbrev-ref HEAD)

if [[ "${PREVIOUS_HEAD}" = HEAD ]]; then
    echo "you are in a detached HEAD state, please checkout to a brabch"
    return 1
fi

if [[ $(git diff --stat) != '' ]]; then
    echo "    your current directory has unsaved changes, please save or stash them
before running this script"
    return 1
fi

echo "parsing the diff from each commit since master..."
COMMITS_SINCE_MASTER=$(git log master..dynamic-func-pickling-pure-python  --pretty=format:"%H")
n_new_tests=0
for commit in $COMMITS_SINCE_MASTER; do
    git checkout "${commit}" >/dev/null 2>&1
    # grep command find lines matching a test definition added in the diff
    # sed command extract the name of the test
    new_tests=$(git diff HEAD~1 Lib/test/pickletester.py | \
        grep -e '^[+]\+\s\+def\stest\_' | \
        sed -n "s/^+\s\+def\s\(.*\).*(.*)\:$/\1/p")

    if [[ -n  ${new_tests} ]]; then
        for test in ${new_tests}; do
            let n_new_tests++
            echo "commit  ${commit:0:7}  added ${test}"
        done
    fi
done

echo "updating the added_tests.txt file with new entries"
new_tests=$(git diff master..dynamic-func-pickling-pure-python Lib/test/pickletester.py | \
    grep -e '^[+]\+\s\+def\stest\_' | \
    sed -n "s/^+\s\+def\s\(.*\).*(.*)\:$/\1/p")
for test in ${new_tests}; do
    is_in_new_test_summary_file=$(grep "${test}" added_tests.txt)
    if [[ -z ${is_in_new_test_summary_file} ]]; then
        echo "adding: ${test} in the summary file"
        printf "%s\n" "${test}" >> added_tests.txt
    fi
done

git checkout "${PREVIOUS_HEAD}" >/dev/null 2>&1



