
object rolando{
    var property hechizoPreferido = espectroMalefico
    const property valorBase = 3
    var property skillLuchaBase = 1
    var property artefactos = [espadaDelDestino,collar,armadura,mascaraOscura,espejo]

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
}
object ningunArtefacto{
    method aporte(soldado) = 0
}
class Armadura{
    const property valorBase = 2
    const property tipoRefuerzo

    method aporte(soldado) = valorBase + tipoRefuerzo.aporte(soldado)
}

object cotaDeMalla{
    method aporte(soldado) = 1
}

object bendicion{
    method aporte(soldado) = soldado.nivelHechizeria()
}

object ningun{
    method aporte(soldado) = 0
}

class Hechizo{
    var property nombre

    method poder() = nombre.size()
    method esPoderoso() = nombre.size() > 15
    method aporte(soldado) = self.poder()
}

const espectroMalefico = new Hechizo(nombre="espectro Malefico")
const hechizoBasico = new Hechizo(nombre="hechizo Basico")

object fuerzaOscura{
    var property valor = 5

    method valorXfactor(factor){self.valor(valor*factor)}
}

object mundo{
    method eclipse(factor){fuerzaOscura.valorXfactor(factor)}
}

object espadaDelDestino{
    method aporte(soldado) = 3
}

class CollarDivino{
    const property perlas

    method aporte(soldado) = perlas
}

object mascaraOscura{
    method aporte(soldado) = aux.max(4,fuerzaOscura.valor()/2)
}

object espejo{
    method aporte(soldado) = soldado.mejorArtefacto().aporte(soldado)
}

class LibroHechizeria{
    var property hechizos

    method aporte(soldado) = hechizos.sum{hechizo => hechizo.poder()}
    method esPoderoso() = hechizos.any{hechizo=> hechizo.esPoderoso()}
}

const collar = new CollarDivino(perlas = 5)
const armadura = new Armadura(tipoRefuerzo = ningun)

object aux{
    method min(a,b){if(a>b)return b else return a}
    method max(a,b){if(a>b)return a else return b}
}
