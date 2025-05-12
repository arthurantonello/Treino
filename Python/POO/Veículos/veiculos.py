from abc import ABC, abstractmethod

class Veiculo(ABC):
    def __init__(self, marca, modelo, ano) -> None:
        self.marca = marca
        self.modelo = modelo
        self.ano = int(ano)

    def ligar(self):
        return 'Veículo ligado.'

    def desligar(self):
        return 'Veículo desligado.'

    @abstractmethod # Obriga a implementação nas subclasses
    def exibir_informacoes(self):
        pass


class VeiculoCombustao(Veiculo):
    def __init__(self, marca, modelo, ano, capacidade_tanque) -> None:
        super().__init__(marca, modelo, ano)
        self.capacidade_tanque = capacidade_tanque
        self.tanque = 0

    def exibir_informacoes(self):
        return f"""
        Marca: {self.marca}
        Modelo: {self.modelo}
        Ano: {self.ano}
        Quantidade de combustível atual: {self.tanque}
        Capacidade do tanque: {self.capacidade_tanque}
        """
    
    def abastecer(self, litros):
        try:
            if not(0 < self.tanque + litros <= self.capacidade_tanque):
                raise ValueError ('Tanque cheio ou quantidade inválida')
            
            print(f'Tanque abastecido com {litros} litros')
            self.tanque += litros
            return True
        except ValueError as e:
            print(f'Erro no abastecimento: {e}')
            return False
        
class VeiculoEletrico(Veiculo):
    def __init__(self, marca, modelo, ano, capacidade) -> None:
        super().__init__(marca, modelo, ano)

        try:
            self.capacidade = float(capacidade)
            if self.capacidade < 0:
                raise ValueError('Capacidade deve ser maior que zero')
        except (ValueError, TypeError):
            raise ValueError(f'Capacidade inválida: {capacidade} (use um número positivo.)')
        
    def exibir_informacoes(self):
        return f"""
        Marca: {self.marca}
        Modelo: {self.modelo}
        Ano: {self.ano}
        Capacidade da bateria: {self.capacidade}
        """
    
    def carregar_bateria(self, porcentagem):
        try:
            if not (0 < self.capacidade + porcentagem <= 100):
                raise ValueError('Capacidade cheia ou porcentagem de carregamento inválida.')
            
            self.capacidade += porcentagem
            print(f'Capacidade de carregamento atualizada para {self.capacidade}%')
            return True
        except ValueError as e:
            print(f'Erro no carregamento: {e}')
            return False

class Carro(VeiculoCombustao):
    def __init__(self, marca, modelo, ano, capacidade_tanque, numero_portas) -> None:
        super().__init__(marca, modelo, ano, capacidade_tanque)

        try:
            self.numero_portas = int(numero_portas)
            if self.numero_portas < 1:
                raise ValueError('A quantidade mínima de portas deve ser 1.')
        except (ValueError, TypeError):
            raise ValueError(f'Número de portas inválido: {numero_portas} (use um número inteiro positivo)')
        
    def ligar(self):
        return 'Carro ligado'
    

class Moto(VeiculoCombustao):
    def __init__(self, marca, modelo, ano, capacidade_tanque, cilindradas) -> None:
        super().__init__(marca, modelo, ano, capacidade_tanque)

        try:
            self.cilindradas = int(cilindradas)
            if self.cilindradas <= 1:
                raise ValueError('A quantidade mínima de cilindradas é 1.')
        except (ValueError, TypeError):
            raise ValueError(f'Número de cilindradas inválido: {cilindradas} (use um número inteiro positivo)')
        
    def desligar(self):
        return 'Moto desligada'

class CaminhaoEletrico(VeiculoEletrico):
    def __init__(self, marca, modelo, ano, capacidade, capacidade_carga) -> None:
        super().__init__(marca, modelo, ano, capacidade)

        try:
            self.capacidade_carga = float(capacidade_carga)
            if self.capacidade_carga < 1:
                raise ValueError('A quantidade de carga mínima é 1kg')
        except (ValueError, TypeError):
            raise ValueError(f'Capacidade de carga inválida: {capacidade_carga} (use um número positivo)')
        
    def exibir_informacoes(self):
        return f"""
        Marca: {self.marca}
        Modelo: {self.modelo}
        Ano: {self.ano}
        Capacidade da bateria: {self.capacidade}
        Capacidade de carga: {self.capacidade_carga}kg
        """
    

veiculos = [
    Carro("Ford", "Focus", 2022, 45.0, 4),
    Moto("Honda", "CBR 600", 2021, 15.0, 600),
    CaminhaoEletrico("Tesla", "Semi", 2023, 800, 36000)
]

for veiculo in veiculos:
    print(veiculo.exibir_informacoes())
    print(veiculo.ligar())
    print(veiculo.desligar())