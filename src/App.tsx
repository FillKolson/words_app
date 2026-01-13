import React from 'react';

function App() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full text-center">
        <h1 className="text-3xl font-bold text-gray-800 mb-4">Words App</h1>
        <p className="text-gray-600 mb-6">
          This is a Flutter mobile application. The main source code is in the <code className="bg-gray-100 px-2 py-1 rounded">lib/</code> directory.
        </p>
        <div className="bg-indigo-50 rounded-lg p-4 text-left">
          <h2 className="font-semibold text-indigo-800 mb-2">Flutter Project Structure:</h2>
          <ul className="text-sm text-indigo-700 space-y-1">
            <li>📁 <code>lib/main.dart</code> - App entry point</li>
            <li>📁 <code>lib/screens/</code> - UI screens</li>
            <li>📁 <code>lib/models/</code> - Data models</li>
            <li>📁 <code>lib/providers/</code> - State management</li>
          </ul>
        </div>
        <p className="text-sm text-gray-500 mt-6">
          This React wrapper enables Tempo canvas support for your Flutter project.
        </p>
      </div>
    </div>
  );
}

export default App;
