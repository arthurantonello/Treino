ondas = []


function defesaOndas(ondas, habilidadeDeAtaque) {
    let turnos = 0;
    let poderHabilidade = habilidadeDeAtaque;
  
    for (const onda of ondas) {
      const { inimigos, vidaInimigo } = onda;
      let fila = new Array(inimigos).fill(vidaInimigo);
  
      while (fila.length > 0) {
        turnos++;
  
        // Reduz vida dos inimigos pela habilidade de ataque (aplicado a todos)
        fila = fila.map(vida => vida - habilidadeDeAtaque);
  
        // Usa a habilidade especial para eliminar o primeiro inimigo com vida menor ou igual ao poder atual
        for (let i = 0; i < fila.length; i++) {
          if (fila[i] <= poderHabilidade) {
            fila.splice(i, 1);
            break;
          }
        }
  
        // Remove inimigos mortos (vida <= 0)
        fila = fila.filter(vida => vida > 0);
  
        // Aumenta o poder da habilidade em +5 ao final do turno
        poderHabilidade += 5;
        
        // Se habilidade de ataque chegar a 0, e ainda tiver inimigos, derrota
        if (habilidadeDeAtaque <= 0 && fila.length > 0) {
          return -1;
        }
  
        // Habilidade de ataque reduz 1 por turno
        habilidadeDeAtaque--;
  
        // Se ataque chegou a 0 e ainda tem mais ondas pela frente, derrota
        if (habilidadeDeAtaque <= 0 && (fila.length > 0 || ondas.indexOf(onda) < ondas.length - 1)) {
          return -1;
        }
      }
    }
  
    return turnos;
  }

  const ondas2 = [
    { inimigos: 10, vidaInimigo: 15 },
    { inimigos: 5, vidaInimigo: 60 }
  ];
  const habilidade2 = 100;
  
  console.log(defesaOndas(ondas2, habilidade2)); // Esperado: 5
  
  
  