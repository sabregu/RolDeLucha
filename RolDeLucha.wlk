class Jugador{
    var property hechizoPreferido
    const property valorBase1 = valorBase.valorBase()
    var property skillLuchaBase = 1
    var property artefactos 
    var property monedasDeOro = 100
    const property capacidadMaxima

    method agregarArtefacto(artefacto){
        if(capacidadMaxima < self.pesoTotalArtefactos()+artefacto.pesoTotal(self) ){
            throw new MessageNotUnderstoodException(message = "el peso del item supera la capacidad maxima")
        }
        else{artefactos.add(artefacto)}}
    method quitarArtefacto(artefacto) = artefactos.remove(artefacto)
    method habilidadLucha() = skillLuchaBase + artefactos.sum{artefacto => artefacto.aporte(self)}
    method seCreePoderoso() = hechizoPreferido.esPoderoso()
    method nivelHechizeria() = valorBase1 * hechizoPreferido.poder()+ fuerzaOscura.valor()
    method enQueEsMejor(){
        if(self.nivelHechizeria() > self.habilidadLucha()){
            return "es mas fuerte en hechizeria"
        }else{return "es mas fuerte en lucha"}
    }
    method estaCargado() = artefactos.size() > 5
    method gastarMonedasOro(num){monedasDeOro = monedasDeOro - num}
    method puedePagar(num) = monedasDeOro >= num
    method cumplirObjetivo() {self.monedasDeOro(monedasDeOro+10)}
    method nuevoHechizoFavorito(hechizo){hechizoPreferido = hechizo}
    method pesoTotalArtefactos() = artefactos.sum{artefacto => artefacto.pesoTotal(self)}
}

object valorBase{
    var property valorBase = 3
}

object ningunArtefacto{
    method aporte(soldado) = 0
}

// HECHIZOS
class Hechizo{
    var property nombre
    
    method precioLista(soldado) = self.poder()
    method poder() = nombre.size()
    method esPoderoso() = self.poder() > 15

    //Armaduras con hechizo
    method precio(soldado,armadura) = armadura.valorBase()+self.precioLista(soldado)
    method aporte(soldado) = self.poder()
    method pesoPropio(soldado){
        if(self.poder()%2 == 0){
            return 2
        }else{return 1}
    }
}

class Logos inherits Hechizo(){
    var property valor

    override method poder() = nombre.size() * valor
}

class Comercial inherits Hechizo(){
    var property factor
    var property multiplicador

    override method poder() = super()*factor *multiplicador 
}

// ARTEFACTOS
class Artefacto{
    const property peso
    const property diasComprado

    method pesoPropio(soldado)
    method pesoTotal(soldado) = peso - self.factorCorreccion() + self.pesoPropio(soldado)
    method factorCorreccion() = aux.min(1,diasComprado/1000)
    method aporte(soldado)
    method precioLista(soldado)
}
object fuerzaOscura{
    var property valor = 5

    method valorXfactor(factor){self.valor(valor*factor)}
}

object mundo{
    method eclipse(factor){fuerzaOscura.valorXfactor(factor)}
}

class Armas inherits Artefacto(){
    override method pesoPropio(soldado) = 0

    override method precioLista(soldado) = peso*5

    override method aporte(soldado) = 3
}

class CollarDivino inherits Artefacto(peso = 0){
    const property perlas = 5

    override method precioLista(soldado) = 5*perlas
    override method aporte(soldado) = perlas
    override method pesoPropio(soldado) = 0.5*perlas
}

class MascaraOscura inherits Artefacto{
    const  indiceOscuro
    var property minimo = 4

    override method precioLista(soldado) = 10*indiceOscuro

    override method aporte(soldado) = aux.max(minimo,fuerzaOscura.valor()/2 *indiceOscuro)
    method indiceOscuro() = aux.max(0,aux.min(1,indiceOscuro))
    override method pesoPropio(soldado) = aux.max(0,self.aporte(soldado) - 3)
}

class Espejo inherits Artefacto(peso = 0){
    override method precioLista(soldado) = 90

    override method aporte(soldado) = soldado.mejorArtefacto().aporte(soldado)
}

class LibroHechizeria inherits Artefacto(peso = 0){
    var property hechizos

    override method precioLista(soldado){
        hechizos.filter{hechizo => hechizo.esPoderoso()}

        const pepe = 10*hechizos.size() + hechizos.sum{hechizo => hechizo.poder()}

        return pepe
    }

    override method aporte(soldado) = hechizos.sum{hechizo => hechizo.poder()}
    method esPoderoso() = hechizos.any{hechizo=> hechizo.esPoderoso()}
}
// ARMADURAS
class Armadura inherits Artefacto{
    const property valorBase
    const property tipoRefuerzo

    override method aporte(soldado) = valorBase + tipoRefuerzo.aporte(soldado)
    override method precioLista(soldado) = tipoRefuerzo.precio(soldado,self)
    override method pesoPropio(soldado) = tipoRefuerzo.pesoPropio()
}

object cotaDeMalla{
    method aporte(soldado) = 1
    method precio(soldado,armadura) = self.aporte(soldado)/2
    method pesoPropio() = 1
} 

object bendicion{
    method aporte(soldado) = soldado.nivelHechizeria()
    method precio(soldado,armadura) = armadura.valorBase()
    method pesoPropio(soldado) = 0
}

object ningun{
    method aporte(soldado) = 0
    method pesoPropio(soldado) = 0
}

// FERIA DE HECHIZERIA
object feria{
    
}

// NPC
class NPC inherits Jugador{
    var property nivel

    override method habilidadLucha() = super() * nivel.magnitud()
}

class Dificultad{
    const property magnitud
}

const facil = new Dificultad(magnitud = 1)
const moderado = new Dificultad(magnitud = 2)
const dificil = new Dificultad(magnitud = 4)

// COMERCIOS
class Comercio{
    var property itemsDisponibles
    var property tipoComerciante

    method comprarHechizo(soldado,nuevoHechizo){
        const medioPago = soldado.hechizoPreferido().precioLista(soldado)/2
        const gastoFinal = aux.max(0,nuevoHechizo.precioLista(soldado)-medioPago + tipoComerciante.impuesto(nuevoHechizo,soldado))
        if(soldado.puedePagar(gastoFinal)){
        soldado.nuevoHechizoFavorito(nuevoHechizo)
        soldado.gastarMonedasOro(gastoFinal)}
    }
    
    method comprarArtefacto(soldado,artefacto){
        const gastoFinal = artefacto.precioLista(soldado) + tipoComerciante.impuesto(artefacto,soldado)
        if(soldado.puedePagar(gastoFinal)){
        soldado.agregarArtefacto(artefacto)
        soldado.gastarMonedasOro(gastoFinal)}
    }
}

// COMERCIANTES
class ComercianteIndependiente{
    const property comision

    method impuesto(item,soldado) = item.precioLista(soldado)*comision
}

object comercianteRegistrado{
    method impuesto(item,soldado) = item.precioLista(soldado)*0.21
}

object comercianteGanancias{
    const property minimoNoImponible = minimoNoImponible1.valor()

    method impuesto(item,soldado){
        if(item.precioLista(soldado) < minimoNoImponible){
            return 0
        }else{return (item.precioLista(soldado) - minimoNoImponible)*0.35}
    }
}

object minimoNoImponible1{
    var property valor = 5
}

// AUX
object aux{
    method min(a,b){if(a>b)return b else return a}
    method max(a,b){if(a>b)return a else return b}
}

// TESTS

const xenia = new Jugador(hechizoPreferido = logo,artefactos= [],capacidadMaxima = 99999)
const thor = new Jugador(hechizoPreferido = basico,artefactos=[],capacidadMaxima = 99999)
const loki = new Jugador(hechizoPreferido=basico,artefactos=[],monedasDeOro=5, capacidadMaxima = 99999)
const rolando = new Jugador(hechizoPreferido=malefico,artefactos=[], capacidadMaxima = 99999)
const furibunda = new Jugador(hechizoPreferido=comercial,artefactos=[],capacidadMaxima = 99999)
const merlin = new Jugador(hechizoPreferido = null, artefactos = [], capacidadMaxima = 10, monedasDeOro = 100)
const ursula = new Jugador(hechizoPreferido = null, artefactos = [mascar,armadura], capacidadMaxima = 200, monedasDeOro = 100)

const logo = new Logos(nombre = "alacachula cachicomula",valor = 1)
const basico = new Hechizo(nombre = "hechizo basico")
const malefico = new Logos(nombre = "espectro malefico",valor = 1)
const comercial = new Comercial(nombre ="el hechizo comercial",factor = 0.2,multiplicador = 2)

const espadaVieja = new Armas(peso = 7,diasComprado = 6794)
const espadaNueva = new Armas(peso = 4,diasComprado = 0)
const espadaComun = new Armas(peso = 5,diasComprado = 500)
const mascar = new MascaraOscura(peso = 3,indiceOscuro = 1,diasComprado =0)
const mascaraClara = new MascaraOscura(peso = 2,indiceOscuro = 1,diasComprado = 0)
const armadura = new Armadura(valorBase =1,peso = 10,tipoRefuerzo= cotaDeMalla,diasComprado = 0)
const armaduraHechizoPar = new Armadura(valorBase= 1,peso = 12,tipoRefuerzo = comercial,diasComprado = 0)
const armaduraHechizoImpar = new Armadura(valorBase=1,peso=12,tipoRefuerzo = malefico,diasComprado = 0)
const armaduraNormal = new Armadura(valorBase = 1,peso = 12, tipoRefuerzo = ningun, diasComprado = 0)
const collar = new CollarDivino(diasComprado = 0)

const mockHnos = new Comercio(itemsDisponibles = [],tipoComerciante = new ComercianteIndependiente(comision = 0))

const navi = new NPC(hechizoPreferido = null, artefactos = [], capacidadMaxima = 0,nivel = facil)
const ashleyGraham = new NPC(hechizoPreferido = null, artefactos = [mascaraClara], capacidadMaxima = 0, nivel = moderado, skillLuchaBase = 5)

const pastoriza = new Comercio(itemsDisponibles = [],tipoComerciante = new ComercianteIndependiente(comision = 0.09))
const prieto = new Comercio(itemsDisponibles = [], tipoComerciante = comercianteRegistrado)
const fermepin = new Comercio(itemsDisponibles = [], tipoComerciante = comercianteGanancias)