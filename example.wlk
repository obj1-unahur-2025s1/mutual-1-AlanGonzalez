class Viajes {
    var property idiomas = #{}
    method idioma() = idiomas
    method implicaEsfuerzo()
    method bronceo()
    method diasActividad()
    method viajeInteresante() = idiomas.size() > 1
    method recomendada(unSocio) = self.viajeInteresante() && unSocio.leAtrae(self) && unSocio.actividadesEsforzadas().contains(self)
}

class ViajeDePlaya inherits Viajes {
    var property largoPlaya
    override method diasActividad() = largoPlaya / 500
    override method implicaEsfuerzo() = largoPlaya > 1200
    override method bronceo() = true
}

class ExcursionCiudad inherits Viajes {
    var property cantidadAtracciones
    override method diasActividad() = cantidadAtracciones / 2
    override method implicaEsfuerzo() = cantidadAtracciones.between(5, 8)
    override method bronceo() = false
    override method viajeInteresante() = super() || cantidadAtracciones > 5
}

class ExcursionCiudadTropical inherits ExcursionCiudad {
    override method diasActividad() = super() + 1
    override method bronceo() = true

}

class SalidaTrekking inherits Viajes{
    var property senderosRecorridos
    var property diasDeSol
    override method diasActividad() = senderosRecorridos / 50
    override method implicaEsfuerzo() = senderosRecorridos > 80
    override method bronceo() = diasDeSol > 200 || diasDeSol.between(100, 200) && senderosRecorridos > 120
    override method viajeInteresante() = super() && diasDeSol > 140
}


class ClasesGimnasia inherits Viajes {
    override method idioma() = "español"
    override method diasActividad() = 1
    override method implicaEsfuerzo() = true
    override method bronceo() = false
    override method recomendada(unSocio) = unSocio.edad().between(20, 30)
}

class TallerLiterario inherits Viajes {
    var property librosQueTrabaja = []
    method idiomasUsados() = librosQueTrabaja.map({l=>l.idioma()})
    method diasQueLleva() = librosQueTrabaja.size() + 1
    override method implicaEsfuerzo() = librosQueTrabaja.any({l=>l.cantidadPaginas() > 500}) || librosQueTrabaja.map({l=>l.nombreAutor()}).asSet().size() == 1 && librosQueTrabaja.size() > 1
    override method bronceo() = false
    override method recomendada(unSocio) = unSocio.idiomasHablados().size() > 1
}

class Libro {
    var property cantidadPaginas
    var property idioma
    var property nombreAutor 
}

class Socios {
  var property edad
  const property idiomasHablados = #{}
  const actividadesRealizadas = []
  var property maximoDeActividades 
    method actividadesRealizadas() = actividadesRealizadas
    method maximoActividades() = maximoDeActividades
    method adoradorDelSol() = actividadesRealizadas.all({a=>a.bronceo()})
    method actividadesEsforzadas() =actividadesRealizadas.filter({a=>a.implicaEsfuerzo()})
    method realizarActividad(unaActividad) {
      if(actividadesRealizadas.size() == maximoDeActividades){
        throw new Exception(message = "ya realizaste la cantidad maxima de actividades")
      }
      actividadesRealizadas.add(unaActividad)
    }
    method leAtrae(unaActividad)

}

class SocioTranquilo inherits Socios {
    override method leAtrae(unaActividad) = unaActividad.diasActividad() >= 4
}

class SocioCoherente inherits Socios {
    override method leAtrae(unaActividad) = if(self.adoradorDelSol()) unaActividad.bronceo() else unaActividad.implicaEsfuerzo()
}

class SocioRelajado inherits Socios {
    override method leAtrae(unaActividad) = !self.idiomasHablados().intersection(unaActividad.idiomas()).isEmpty()
}