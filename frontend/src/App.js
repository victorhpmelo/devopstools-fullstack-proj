import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3001';

function App() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({ name: '', description: '' });
  const [editingId, setEditingId] = useState(null);
  const [message, setMessage] = useState({ type: '', text: '' });

  useEffect(() => {
    fetchItems();
  }, []);

  const fetchItems = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API_URL}/api/items`);
      if (response.data.success) {
        setItems(response.data.data);
      }
    } catch (error) {
      showMessage('error', 'Erro ao carregar itens');
      console.error('Error fetching items:', error);
    } finally {
      setLoading(false);
    }
  };

  const showMessage = (type, text) => {
    setMessage({ type, text });
    setTimeout(() => setMessage({ type: '', text: '' }), 3000);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editingId) {
        // Update
        const response = await axios.put(
          `${API_URL}/api/items/${editingId}`,
          formData
        );
        if (response.data.success) {
          showMessage('success', 'Item atualizado com sucesso!');
          setFormData({ name: '', description: '' });
          setEditingId(null);
          fetchItems();
        }
      } else {
        // Create
        const response = await axios.post(`${API_URL}/api/items`, formData);
        if (response.data.success) {
          showMessage('success', 'Item criado com sucesso!');
          setFormData({ name: '', description: '' });
          fetchItems();
        }
      }
    } catch (error) {
      showMessage('error', 'Erro ao salvar item');
      console.error('Error saving item:', error);
    }
  };

  const handleEdit = (item) => {
    setFormData({ name: item.name, description: item.description || '' });
    setEditingId(item.id);
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Tem certeza que deseja excluir este item?')) {
      return;
    }
    try {
      const response = await axios.delete(`${API_URL}/api/items/${id}`);
      if (response.data.success) {
        showMessage('success', 'Item excluído com sucesso!');
        fetchItems();
      }
    } catch (error) {
      showMessage('error', 'Erro ao excluir item');
      console.error('Error deleting item:', error);
    }
  };

  return (
    <div className="App">
      <div className="container">
        <header>
          <h1>🚀 Projeto DevOps</h1>
          <p>Gerenciamento de Itens - CRUD Completo</p>
        </header>

        {message.text && (
          <div className={`message message-${message.type}`}>
            {message.text}
          </div>
        )}

        <div className="form-container">
          <h2>{editingId ? 'Editar Item' : 'Criar Novo Item'}</h2>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label htmlFor="name">Nome *</label>
              <input
                type="text"
                id="name"
                value={formData.name}
                onChange={(e) =>
                  setFormData({ ...formData, name: e.target.value })
                }
                required
                placeholder="Digite o nome do item"
              />
            </div>
            <div className="form-group">
              <label htmlFor="description">Descrição</label>
              <textarea
                id="description"
                value={formData.description}
                onChange={(e) =>
                  setFormData({ ...formData, description: e.target.value })
                }
                placeholder="Digite a descrição do item"
                rows="3"
              />
            </div>
            <div className="form-actions">
              <button type="submit" className="btn btn-primary">
                {editingId ? 'Atualizar' : 'Criar'}
              </button>
              {editingId && (
                <button
                  type="button"
                  className="btn btn-secondary"
                  onClick={() => {
                    setFormData({ name: '', description: '' });
                    setEditingId(null);
                  }}
                >
                  Cancelar
                </button>
              )}
            </div>
          </form>
        </div>

        <div className="items-container">
          <h2>Lista de Itens ({items.length})</h2>
          {loading ? (
            <div className="loading">Carregando...</div>
          ) : items.length === 0 ? (
            <div className="empty-state">Nenhum item cadastrado ainda.</div>
          ) : (
            <div className="items-grid">
              {items.map((item) => (
                <div key={item.id} className="item-card">
                  <div className="item-header">
                    <h3>{item.name}</h3>
                    <div className="item-actions">
                      <button
                        className="btn-icon btn-edit"
                        onClick={() => handleEdit(item)}
                        title="Editar"
                      >
                        ✏️
                      </button>
                      <button
                        className="btn-icon btn-delete"
                        onClick={() => handleDelete(item.id)}
                        title="Excluir"
                      >
                        🗑️
                      </button>
                    </div>
                  </div>
                  {item.description && (
                    <p className="item-description">{item.description}</p>
                  )}
                  <div className="item-footer">
                    <small>
                      Criado em:{' '}
                      {new Date(item.created_at).toLocaleString('pt-BR')}
                    </small>
                    {item.updated_at !== item.created_at && (
                      <small>
                        Atualizado em:{' '}
                        {new Date(item.updated_at).toLocaleString('pt-BR')}
                      </small>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default App;


