const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Database connection
const pool = new Pool({
  host: process.env.DB_HOST || 'postgres',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'devopsdb',
  user: process.env.DB_USER || 'devopsuser',
  password: process.env.DB_PASSWORD || 'devopspass'
});

// Initialize database table
const initDatabase = async () => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS items (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    console.log('Database initialized successfully');
  } catch (error) {
    console.error('Error initializing database:', error);
  }
};

// Routes

// GET - List all items
app.get('/api/items', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM items ORDER BY created_at DESC');
    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows
    });
  } catch (error) {
    console.error('Error fetching items:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching items',
      error: error.message
    });
  }
});

// GET - Get single item by ID
app.get('/api/items/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM items WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Item not found'
      });
    }
    
    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Error fetching item:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching item',
      error: error.message
    });
  }
});

// POST - Create new item
app.post('/api/items', async (req, res) => {
  try {
    const { name, description } = req.body;
    
    if (!name) {
      return res.status(400).json({
        success: false,
        message: 'Name is required'
      });
    }
    
    const result = await pool.query(
      'INSERT INTO items (name, description) VALUES ($1, $2) RETURNING *',
      [name, description || null]
    );
    
    res.status(201).json({
      success: true,
      message: 'Item created successfully',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Error creating item:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating item',
      error: error.message
    });
  }
});

// PUT - Update item
app.put('/api/items/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description } = req.body;
    
    if (!name) {
      return res.status(400).json({
        success: false,
        message: 'Name is required'
      });
    }
    
    const result = await pool.query(
      'UPDATE items SET name = $1, description = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $3 RETURNING *',
      [name, description || null, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Item not found'
      });
    }
    
    res.json({
      success: true,
      message: 'Item updated successfully',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Error updating item:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating item',
      error: error.message
    });
  }
});

// DELETE - Delete item
app.delete('/api/items/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM items WHERE id = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Item not found'
      });
    }
    
    res.json({
      success: true,
      message: 'Item deleted successfully',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Error deleting item:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting item',
      error: error.message
    });
  }
});

// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({
      status: 'healthy',
      database: 'connected',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: error.message
    });
  }
});

// Start server
app.listen(PORT, async () => {
  console.log(`Server running on port ${PORT}`);
  await initDatabase();
});


