package com.ligajusticia.menu.model;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * Entidad Acceso
 * Registra el historial de accesos de usuarios a opciones de menú
 * Útil para auditoría y análisis de uso
 */
@Entity
@Table(name = "acceso", indexes = {
    @Index(name = "idx_acceso_usuario", columnList = "usuario_id"),
    @Index(name = "idx_acceso_opcion", columnList = "opcion_id"),
    @Index(name = "idx_acceso_fecha", columnList = "fecha_acceso")
})
public class Acceso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "fecha_acceso", nullable = false)
    private LocalDateTime fechaAcceso;

    @Column(name = "ip_address", length = 50)
    private String ipAddress;

    @Column(name = "user_agent", length = 500)
    private String userAgent;

    @Column(name = "accion_realizada", length = 200)
    private String accionRealizada;

    @Column(nullable = false)
    private Boolean exitoso = true;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "opcion_id")
    private Opcion opcion;

    @PrePersist
    protected void onCreate() {
        if (fechaAcceso == null) {
            fechaAcceso = LocalDateTime.now();
        }
    }

    // Constructores
    public Acceso() {
    }

    public Acceso(Usuario usuario, Opcion opcion) {
        this.usuario = usuario;
        this.opcion = opcion;
        this.fechaAcceso = LocalDateTime.now();
    }

    // Getters y Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDateTime getFechaAcceso() {
        return fechaAcceso;
    }

    public void setFechaAcceso(LocalDateTime fechaAcceso) {
        this.fechaAcceso = fechaAcceso;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getAccionRealizada() {
        return accionRealizada;
    }

    public void setAccionRealizada(String accionRealizada) {
        this.accionRealizada = accionRealizada;
    }

    public Boolean getExitoso() {
        return exitoso;
    }

    public void setExitoso(Boolean exitoso) {
        this.exitoso = exitoso;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Opcion getOpcion() {
        return opcion;
    }

    public void setOpcion(Opcion opcion) {
        this.opcion = opcion;
    }
}
