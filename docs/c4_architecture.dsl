workspace "SentinelOps - System Context" "Centralized Enterprise Compliance Backbone" {

    model {

        admin = person "Enterprise Administrator" {
            description "Receives compliance-aware advisories and makes authoritative operational decisions."
        }

        complianceOfficer = person "Compliance Officer" {
            description "Defines policies, reviews decisions, and audits compliance alignment."
        }

        regulator = person "Regulator / External Auditor" {
            description "Reviews traceability records and validates regulatory adherence."
        }

        operationalSystems = softwareSystem "Enterprise Operational Systems" {
            description "Identity, cloud, financial, healthcare, configuration, and security systems generating operational signals and executing approved actions."
        }

        sentinelOps = softwareSystem "SentinelOps" {
            description "Centralized compliance-aware advisory and governance backbone that evaluates operational signals, generates policy-aligned recommendations, and records full decision lifecycle immutably."

            ingestion = container "Event Ingestion Layer" {
                technology "API / Event Processor"

                receiver = component "Event Receiver"
                normalizer = component "Event Normalizer"
                router = component "Event Router"

                receiver -> normalizer
                normalizer -> router
            }

            policyEngine = container "Policy & Regulatory Engine" {
                technology "Policy Evaluation Service"

                policyRepository = component "Policy Repository"
                policyInterpreter = component "Policy Interpreter"
                conflictResolver = component "Conflict Resolver"
                policyEvaluator = component "Policy Evaluation Engine"

                policyRepository -> policyInterpreter
                policyInterpreter -> conflictResolver
                conflictResolver -> policyEvaluator
            }

            riskEngine = container "Risk Scoring Engine" {
                technology "Risk Evaluation Service"

                riskModelManager = component "Risk Model Manager"
                riskCalculator = component "Risk Calculator"
                riskClassifier = component "Risk Classifier"

                riskModelManager -> riskCalculator
                riskCalculator -> riskClassifier
            }

            advisoryEngine = container "Advisory Engine" {
                technology "Advisory Composition Service"

                advisoryComposer = component "Advisory Composer"
                justificationGenerator = component "Justification Generator"
                recommendationEngine = component "Recommendation Engine"

                advisoryComposer -> justificationGenerator
                justificationGenerator -> recommendationEngine
            }

            decisionGovernance = container "Decision Governance Service" {
                technology "Governance Control Service"

                authorityValidator = component "Authority Validator"
                decisionRecorder = component "Decision Recorder"
                escalationManager = component "Escalation Manager"
                stateController = component "Decision State Controller"
                ledgerAdapter = component "Ledger Commit Adapter"

                authorityValidator -> decisionRecorder
                decisionRecorder -> stateController
                stateController -> ledgerAdapter
                escalationManager -> stateController
            }

            ledger = container "Immutable Audit Ledger" {
                technology "Immutable Data Store"

                ledgerWriter = component "Append-Only Writer"
                hashGenerator = component "Hash Chain Generator"
                ledgerVerifier = component "Ledger Verifier"
                traceIndexer = component "Trace Indexer"

                ledgerWriter -> hashGenerator
                hashGenerator -> ledgerVerifier
                ledgerWriter -> traceIndexer
            }

            executionBridge = container "Execution Bridge" {
                technology "Integration Adapter"

                executionTranslator = component "Execution Translator"
                dispatcher = component "Execution Dispatcher"
                acknowledgmentListener = component "Acknowledgment Listener"

                executionTranslator -> dispatcher
                dispatcher -> acknowledgmentListener
            }

            adminUI = container "Administrative Decision Surface" {
                technology "Web Application"
            }
        }

        admin -> adminUI "Views advisories and submits decisions"
        complianceOfficer -> adminUI "Reviews policy alignment and audit trails"
        regulator -> adminUI "Accesses traceability and audit reports"

        operationalSystems -> ingestion "Sends operational events"
        decisionGovernance -> executionBridge "Triggers approved execution"
        executionBridge -> operationalSystems "Sends execution instructions"

        ingestion -> policyEngine
        policyEngine -> riskEngine
        policyEngine -> advisoryEngine
        riskEngine -> advisoryEngine
        advisoryEngine -> decisionGovernance
        decisionGovernance -> ledger
        executionBridge -> ledger
        adminUI -> decisionGovernance
        adminUI -> advisoryEngine
        adminUI -> ledger
    }

    views {

        systemContext sentinelOps {
            include *
            autolayout lr
        }

        container sentinelOps {
            include *
            autolayout lr
        }

        component policyEngine {
            include *
            autolayout lr
        }

        component advisoryEngine {
            include *
            autolayout lr
        }

        component decisionGovernance {
            include *
            autolayout lr
        }

        component ledger {
            include *
            autolayout lr
        }

        theme default
    }
}
