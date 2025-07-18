workspace {

    model {
        user = person "Platform Admin" {
            description "Responsible for monitoring infrastructure and application health."
            tags "person"
        }

        monitoringSystem = softwareSystem "Monitoring & Observability Service" {
            description "Collects, processes, stores, and visualizes infrastructure and application metrics/logs."

            Container_MonitoringAgent = container "Monitoring Agent" {
                description "Runs on each host or container, exposing or forwarding metrics and logs to Prometheus and Loki."
                technology "Node Exporter, Promtail, Fluent Bit"
                tags  "Internal"
            }

            Container_Prometheus = container "Prometheus Server" {
                description "Pulls metrics from Monitoring Agents and stores them for querying and alerting."
                technology "Prometheus"
                tags  "Internal"
            }

            Container_Loki = container "Loki Log Aggregator" {
                description "Stores logs pushed from agents like Promtail or Fluent Bit."
                technology "Grafana Loki"
                tags  "Internal"
            }

            Container_Grafana = container "Grafana Dashboard" {
                description "Visualizes metrics and logs using Prometheus and Loki as data sources."
                technology "Grafana"
                tags  "Internal"
            }

            // Internal component to push logs (optional)
            Component_LogPusher = container "Log Pusher" {
                description "Responsible for parsing and pushing logs to Loki."
                technology "Promtail / Fluent Bit"
                tags "Internal"
            }

            // Relationships
            Container_MonitoringAgent -> Container_Prometheus "Exposes metrics over HTTP"
            Container_MonitoringAgent -> Component_LogPusher "Parses and forwards logs"
            Component_LogPusher -> Container_Loki "Pushes structured logs"

            Container_Prometheus -> Container_Grafana "Feeds time-series data"
            Container_Loki -> Container_Grafana "Feeds log data"

            user -> Container_Grafana "Views dashboards and sets up alerts"
        }
    }

    views {
        systemContext monitoringSystem {
            include *
            autolayout lr
            title "Monitoring & Observability Service - System Context"
        }

        container monitoringSystem {
            include *
            autolayout lr
            title "Monitoring & Observability Service - Container View"
        }

        
        styles {
             element "Person" {
        shape person
        background #06B3DE
        color #ffffff
      }

      

       element "Internal" {
        shape RoundedBox
        background #d6f0ff
        stroke #003049
        strokeWidth 6
      }
      
        }
    }
}
