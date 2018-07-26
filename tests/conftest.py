def pytest_addoption(parser):
    parser.addoption("--region", action="store", default="eu-west-2")
    parser.addoption("--branch", action="store", default="local")
    parser.addoption("--commitid", action="store", default="123456")
    parser.addoption("--templateurl", action="store", default="")


def pytest_generate_tests(metafunc):
    # This is called for every test. Only get/set command line arguments
    # if the argument is specified in the list of test "fixturenames".
    option_region = metafunc.config.option.region
    if 'region' in metafunc.fixturenames and option_region is not None:
        metafunc.parametrize("region", [option_region])
    option_branch = metafunc.config.option.branch
    if 'branch' in metafunc.fixturenames and option_branch is not None:
        metafunc.parametrize("branch", [option_branch])
    if 'commitid' in metafunc.fixturenames and metafunc.config.option.commitid is not None:
        metafunc.parametrize("commitid", [metafunc.config.option.commitid])
    if 'templateurl' in metafunc.fixturenames and metafunc.config.option.templateurl is not None:
        metafunc.parametrize("templateurl", [metafunc.config.option.templateurl])
        