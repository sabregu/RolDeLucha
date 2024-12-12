class Rolando{
    var property hechizoPreferido
    const property valorBase = valorBase.valorBase()
    var property skillLuchaBase = 1
    var property artefactos 
    var property monedasDeOro = 100

    method mejorArtefacto(){
        self.quitarArtefacto(espejo)
        const artefactosSinEspejo = self.artefactos()
    if(!artefactosSinEspejo.isEmpty())
    return artefactosSinEspejo.max{artefacto => artefacto.aporte(self)}else{
       return ningunArtefacto
    }
    }
    method agregarArtefacto(artefacto) = artefactos.add(artefacto)
    method quitarArtefacto(artefacto) = artefactos.remove(artefacto)
    method habilidadLucha() = skillLuchaBase + artefactos.sum{artefacto => artefacto.aporte(self)}
    method seCreePoderoso() = hechizoPreferido.esPoderoso()
    method nivelHechizeria() = valorBase * hechizoPreferido.poder()+ fuerzaOscura.valor()
    method enQueEsMejor(){
        if(self.nivelHechizeria() > self.habilidadLucha()){
            return "es mas fuerte en hechizeria"
        }else{return "es mas fuerte en lucha"}
    }
    method estaCargado() = artefactos.size() > 5
    method gastarMonedasOro(num) = monedasDeOro - num
    method puedePagar(num) = monedasDeOro > num
}

object valorBase{
    var property valorBase = 3
}

object ningunArtefacto{
    method aporte(soldado) = 0
}

// ARMADURAS
class Armadura{
    const property valorBase
    const property tipoRefuerzo

    method aporte(soldado) = valorBase + tipoRefuerzo.aporte(soldado)
    method precioLista(soldado) = tipoRefuerzo.precio(soldado,self)
}

object cotaDeMalla{
    method aporte(soldado) = 1
    method precio(soldado,armadura) = self.aporte(soldado)/2
}

object bendicion{
    method aporte(soldado) = soldado.nivelHechizeria()
    method precio(soldado,armadura) = armadura.valorBase()
}

object ningun{
    method aporte(soldado) = 0
}

// HECHIZOS
class Hechizo{
    var property nombre
    
    method precio(soldado,armadura) = armadura.valorBase()+self.precioLista(soldado)
    method precioLista(soldado) = 10
    method poder() = nombre.size()
    method esPoderoso() = self.poder() > 15
    method aporte(soldado) = self.poder()
}

class Logos inherits Hechizo(){
    var property valor

    override method precioLista(soldado) = self.poder()
    override method poder() = nombre.size() * valor
}

// ARTEFACTOS
class Artefacto{
    

    method aporte(soldado)
}
object fuerzaOscura{
    var property valor = 5

    method valorXfactor(factor){self.valor(valor*factor)}
}

object mundo{
    method eclipse(factor){fuerzaOscura.valorXfactor(factor)}
}

class Armas inherits Artefacto(){

    method precioLista(soldado) = self.aporte(soldado)*5

    override method aporte(soldado) = 3
}

class CollarDivino inherits Artefacto{
    const property perlas

    method precioLista(soldado) = 5*perlas
    override method aporte(soldado) = perlas
}

class MascaraOscura inherits Artefacto{
    const  indiceOscuro
    var property minimo

    method precioLista(soldado) = 70 + fuerzaOscura.valor()*indiceOscuro

    override method aporte(soldado) = aux.max(minimo,fuerzaOscura.valor()/2 *indiceOscuro)
    method indiceOscuro() = aux.max(0,aux.min(1,indiceOscuro))
}

object espejo inherits Artefacto(){
    method precioLista(soldado) = 90

    override method aporte(soldado) = soldado.mejorArtefacto().aporte(soldado)
}

class LibroHechizeria inherits Artefacto{
    var property hechizos

    method precioLista(soldado){
        hechizos.filter{hechizo => hechizo.esPoderoso()}

        const pepe = 10*hechizos.size() + hechizos.sum{hechizo => hechizo.poder()}

        return pepe
    }

    override method aporte(soldado) = hechizos.sum{hechizo => hechizo.poder()}
    method esPoderoso() = hechizos.any{hechizo=> hechizo.esPoderoso()}
}

// FERIA DE HECHIZERIA
object feria{
    method comprarHechizo(soldado,nuevoHechizo){
        const medioPago = soldado.hechizoPreferido().precioLista()/2
        const gastoFinal = aux.max(0,nuevoHechizo.precioLista()-medioPago)
        if(soldado.puedePagar(gastoFinal)){
        
        soldado.nuevoHechizoFavorito(nuevoHechizo)
        soldado.gastarMonedasOro(gastoFinal)}
    }
    
    method comprarArtefacto(soldado,artefacto){
        if(soldado.puedePagar(artefacto.precioLista(soldado))){
        soldado.agregarArtefacto(artefacto)
        soldado.gastarMonedasOro(artefacto.precioLista(soldado))}
    }
}

// AUX
object aux{
    method min(a,b){if(a>b)return b else return a}
    method max(a,b){if(a>b)return a else return b}
}
