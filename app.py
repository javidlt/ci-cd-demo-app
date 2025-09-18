"""
A simple Flask web application for the CI/CD demo.
"""
from flask import Flask, jsonify, Response

def create_app() -> Flask:
    """
    Factory function to create and configure the Flask application.
    Using a factory pattern makes the application more modular and easier
    to test and configure.
    """
    app = Flask(__name__)

    @app.route("/")
    def hello() -> Response:
        """
        Endpoint to return a simple greeting.
        
        Returns:
            Response: A JSON response with a greeting message and a 200 status code.
        """
        # Using jsonify creates a JSON response with the correct Content-Type header.
        return jsonify(message="Hello CI/CD!")

    @app.errorhandler(404)
    def not_found_error(error) -> Response:
        """
        Custom error handler for 404 Not Found errors.
        Provides a clear, JSON-formatted error message.
        """
        return jsonify(error="Resource not found"), 404

    @app.errorhandler(500)
    def internal_error(error) -> Response:
        """
        Custom error handler for 500 Internal Server errors.
        Catches unexpected errors and provides a generic response.
        """
        # In a real application, you would log the error details here.
        return jsonify(error="Internal server error"), 500

    return app

if __name__ == "__main__":
    # The app is created using the factory function.
    flask_app = create_app()
    
    # The run command is only executed when the script is run directly.
    # For production, a dedicated WSGI server like Gunicorn should be used
    # instead of Flask's built-in development server.
    flask_app.run(host="0.0.0.0", port=8080)