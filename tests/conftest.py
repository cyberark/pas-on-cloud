import pytest

def pytest_addoption(parser):
    parser.addoption("--region", action="store", default="eu-west-2")
    parser.addoption("--branch", action="store", default="local")
    parser.addoption("--commitid", action="store", default="123456")
    parser.addoption("--templateurl", action="store", default="")


@pytest.fixture
def region(request):
    return request.config.getoption("--region")
    
@pytest.fixture
def branch(request):
    return request.config.getoption("--branch")
    
@pytest.fixture
def commitid(request):
    return request.config.getoption("--commitid")
    
@pytest.fixture
def templateurl(request):
    return request.config.getoption("--templateurl")

        