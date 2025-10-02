package com.ligajusticia.menu.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entidad Opcion
 * Representa una opción dentro de un menú (enlace, acción, etc.)
 */
@Entity
@Table(name = "opcion", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"codigo", "menu_id"})
})
public class Opcion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String codigo;

    @Column(nullable = false, length = 200)
    private String nombre;

    @Column(length = 500)
    private String descripcion;

    @Column(length = 500)
    private String url;

    @Column(length = 100)
    private String icono;

    @Column(nullable = false)
    private Integer orden = 0;

    @Column(nullable = false)
    private Boolean activo = true;

    @Column(name = "tipo_accion", length = 50)
    private String tipoAccion; // Ej: "NAVEGACION", "MODAL", "ACCION_BACKEND"

    @Column(name = "fecha_creacion", nullable = false, updatable = false)
    private LocalDateTime fechaCreacion;

    @Column(name = "fecha_modificacion")
    private LocalDateTime fechaModificacion;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "menu_id", nullable = false)
    private Menu menu;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "opcion_padre_id")
    private Opcion opcionPadre;

    @OneToMany(mappedBy = "opcionPadre", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Opcion> subOpciones = new HashSet<>();

    @OneToMany(mappedBy = "opcion", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Visibilidad> reglas = new HashSet<>();

    @PrePersist
    protected void onCreate() {
        fechaCreacion = LocalDateTime.now();
        fechaModificacion = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        fechaModificacion = LocalDateTime.now();
    }

    // Constructores
    public Opcion() {
    }

    public Opcion(String codigo, String nombre, Menu menu) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.menu = menu;
    }

    // Getters y Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getIcono() {
        return icono;
    }

    public void setIcono(String icono) {
        this.icono = icono;
    }

    public Integer getOrden() {
        return orden;
    }

    public void setOrden(Integer orden) {
        this.orden = orden;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    public String getTipoAccion() {
        return tipoAccion;
    }

    public void setTipoAccion(String tipoAccion) {
        this.tipoAccion = tipoAccion;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public LocalDateTime getFechaModificacion() {
        return fechaModificacion;
    }

    public void setFechaModificacion(LocalDateTime fechaModificacion) {
        this.fechaModificacion = fechaModificacion;
    }

    public Menu getMenu() {
        return menu;
    }

    public void setMenu(Menu menu) {
        this.menu = menu;
    }

    public Opcion getOpcionPadre() {
        return opcionPadre;
    }

    public void setOpcionPadre(Opcion opcionPadre) {
        this.opcionPadre = opcionPadre;
    }

    public Set<Opcion> getSubOpciones() {
        return subOpciones;
    }

    public void setSubOpciones(Set<Opcion> subOpciones) {
        this.subOpciones = subOpciones;
    }

    public Set<Visibilidad> getReglas() {
        return reglas;
    }

    public void setReglas(Set<Visibilidad> reglas) {
        this.reglas = reglas;
    }
}
