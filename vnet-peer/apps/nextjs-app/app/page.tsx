'use client'

import { useEffect, useState } from 'react'
import styles from './page.module.css'

export default function Home() {
  const [apiData, setApiData] = useState<any>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const fetchApiData = async () => {
    setLoading(true)
    setError(null)
    try {
      // This will be proxied through Front Door at /api/*
      const response = await fetch('/api/')
      if (!response.ok) {
        throw new Error('Failed to fetch API data')
      }
      const data = await response.json()
      setApiData(data)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }

  return (
    <main className={styles.main}>
      <div className={styles.container}>
        <h1 className={styles.title}>
          Bienvenido a la App Next.js
        </h1>
        <p className={styles.description}>
          Esta aplicación está alojada en Azure Storage y servida a través de Azure Front Door
        </p>

        <div className={styles.section}>
          <h2>Información de la Aplicación</h2>
          <ul className={styles.infoList}>
            <li>✅ Hosteada en Azure Storage Account</li>
            <li>✅ Servida a través de Azure Front Door</li>
            <li>✅ Comunicación privada con API Management</li>
            <li>✅ API Management se comunica con Container Apps (NestJS)</li>
          </ul>
        </div>

        <div className={styles.section}>
          <h2>Probar API</h2>
          <button 
            onClick={fetchApiData} 
            disabled={loading}
            className={styles.button}
          >
            {loading ? 'Cargando...' : 'Obtener Datos de la API'}
          </button>

          {error && (
            <div className={styles.error}>
              Error: {error}
            </div>
          )}

          {apiData && (
            <div className={styles.apiResponse}>
              <h3>Respuesta de la API:</h3>
              <pre>{JSON.stringify(apiData, null, 2)}</pre>
            </div>
          )}
        </div>

        <div className={styles.section}>
          <h2>Arquitectura</h2>
          <div className={styles.architecture}>
            <div className={styles.flow}>
              <div className={styles.box}>Internet</div>
              <div className={styles.arrow}>→</div>
              <div className={styles.box}>Azure Front Door (Público)</div>
              <div className={styles.arrow}>→</div>
              <div className={styles.box}>Storage Account (Privado)</div>
            </div>
            <div className={styles.flow}>
              <div className={styles.box}>Front Door</div>
              <div className={styles.arrow}>→</div>
              <div className={styles.box}>API Management (Privado)</div>
              <div className={styles.arrow}>→</div>
              <div className={styles.box}>Container Apps - NestJS (Privado)</div>
            </div>
          </div>
        </div>
      </div>
    </main>
  )
}

