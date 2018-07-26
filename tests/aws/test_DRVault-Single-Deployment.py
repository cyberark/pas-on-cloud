import pytest
import boto3

def test_validate():
  assert(1==1)
  
def test_failed():
  assert(1==0)