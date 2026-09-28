export default function Home() {
  return (
    <main>
      <header>
        <strong>Central dos Desempregados</strong>
        <nav><a href="#vagas">Vagas</a><a href="#como-funciona">Como funciona</a></nav>
      </header>
      <section className="hero">
        <div>
          <p className="eyebrow">OPORTUNIDADES EM UM SÓ LUGAR</p>
          <h1>Seu próximo trabalho <span>começa aqui.</span></h1>
          <p>Encontre oportunidades de trabalho organizadas em um só lugar, com busca rápida e acesso ao anúncio original.</p>
          <div className="search"><input placeholder="Cargo, profissão ou palavra-chave" /><input placeholder="Cidade ou estado" /><button>Buscar vagas</button></div>
        </div>
        <aside><b>Central dos Desempregados</b><strong>Milhares de oportunidades</strong><p>Uma plataforma para pesquisar, comparar e encontrar sua próxima oportunidade.</p></aside>
      </section>
      <section id="vagas" className="section"><h2>Oportunidades em destaque</h2><div className="cards">
        {['Motorista Carreteiro','Auxiliar Administrativo','Assistente de Logística'].map((v,i)=><article key={v}><h3>{v}</h3><p>{['Transportadora Brasil','Empresa Regional','Grupo Norte'][i]}</p><span>CLT</span><span>Ver oportunidade →</span></article>)}
      </div></section>
      <section id="como-funciona" className="section"><h2>Menos tempo procurando. Mais tempo se preparando.</h2><p>Busque por cargo e localização, compare informações e siga para a fonte original da oportunidade.</p></section>
      <footer>Central dos Desempregados · Sua próxima oportunidade está aqui.</footer>
    </main>
  );
}