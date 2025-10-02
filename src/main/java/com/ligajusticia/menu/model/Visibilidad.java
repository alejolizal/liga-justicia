package com.ligajusticia.menu.model;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * Entidad Visibilidad
 * Define reglas de visibilidad para opciones de menú según roles
 * Permite extensibilidad para futuras reglas de visibilidad
 */
@Entity
@Table(name = "visibilidad", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"opcion_id", "rol_id"})
})
public class Visibilidad {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Boolean visible = true;

    @Column(nullable = false)
    private Boolean habilitado = true;

    @Column(name = "tipo_regla", length = 50)
    private String tipoRegla; // Ej: "ROL", "NEGOCIO", "PERSONALIZADO"

    @Column(name = "expresion_regla", length = 1000)
    private String expresionRegla; // Expresión para reglas personalizadas extensibles

    @Column(name = "fecha_creacion", nullable = false, updatable = false)
    private LocalDateTime fechaCreacion;

    @Column(name = "fecha_modificacion")
    private LocalDateTime fechaModificacion;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "opcion_id", nullable = false)
    private Opcion opcion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rol_id")
    private Rol rol;

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
    public Visibilidad() {
    }

    public Visibilidad(Opcion opcion, Rol rol, Boolean visible, Boolean habilitado) {
        this.opcion = opcion;
        this.rol = rol;
        this.visible = visible;
        this.habilitado = habilitado;
    }

    // Getters y Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Boolean getVisible() {
        return visible;
    }

    public void setVisible(Boolean visible) {
        this.visible = visible;
    }

    public Boolean getHabilitado() {
        return habilitado;
    }

    public void setHabilitado(Boolean habilitado) {
        this.habilitado = habilitado;
    }

    public String getTipoRegla() {
        return tipoRegla;
    }

    public void setTipoRegla(String tipoRegla) {
        this.tipoRegla = tipoRegla;
    }

    public String getExpresionRegla() {
        return expresionRegla;
    }

    public void setExpresionRegla(String expresionRegla) {
        this.expresionRegla = expresionRegla;
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

    public Opcion getOpcion() {
        return opcion;
    }

    public void setOpcion(Opcion opcion) {
        this.opcion = opcion;
    }

    public Rol getRol() {
        return rol;
    }

    public void setRol(Rol rol) {
        this.rol = rol;
    }
}
