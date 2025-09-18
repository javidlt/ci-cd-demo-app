import pytest
import json
from app import create_app

def test_truth():
    """Basic sanity test"""
    assert 2 + 2 == 4

class TestFlaskApp:
    """Test suite for the Flask application"""
    
    @pytest.fixture
    def app(self):
        """Create application for testing"""
        app = create_app()
        app.config['TESTING'] = True
        return app
    
    @pytest.fixture
    def client(self, app):
        """Create test client"""
        return app.test_client()
    
    def test_hello_endpoint(self, client):
        """Test the main hello endpoint"""
        response = client.get('/')
        assert response.status_code == 200
        
        data = json.loads(response.data)
        assert data['message'] == 'Hello CI/CD!'
        assert response.content_type == 'application/json'
    
    def test_404_error_handler(self, client):
        """Test 404 error handling"""
        response = client.get('/nonexistent')
        assert response.status_code == 404
        
        data = json.loads(response.data)
        assert 'error' in data
        assert data['error'] == 'Resource not found'
    
    def test_app_creation(self):
        """Test that app can be created"""
        app = create_app()
        assert app is not None
        assert app.config['TESTING'] is False
    
    def test_json_response_headers(self, client):
        """Test that responses have correct JSON headers"""
        response = client.get('/')
        assert 'application/json' in response.content_type
