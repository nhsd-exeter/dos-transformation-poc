import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('empty test', () => {
  render(<App />);
  const item = true;
  expect(item).toBe(true);
});
