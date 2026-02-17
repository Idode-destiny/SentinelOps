# Phase 4: Component Decomposition

## C4 Level 3: SentinelOps Internal Structure

---

## 1. Event Ingestion Layer

### Responsibility

**Pure observation and normalization.**

### Components

#### Event Receiver
**Accepts inbound signals from operational systems.**

#### Source Validator
**Verifies integrity, authentication, signature.**

#### Event Normalizer
**Converts raw payload into canonical Event Domain format.**

#### Event Router
**Publishes normalized event to evaluation pipeline.**

### Interfaces

**Provides:**
- **NormalizedEvent**

**Requires:**
- **Source identity validation service**

**No policy logic here. No risk logic here.**

---

## 2. Policy & Regulatory Engine

**This is the compliance brain.**

### Components

#### Policy Repository
**Stores internal policies.**

#### Regulatory Mapping Registry
**Maps internal policies to external regulations.**

#### Policy Interpreter
**Converts declarative policy definitions into executable evaluation logic.**

#### Conflict Resolver
**Detects policy contradictions and defines resolution priority.**

#### Policy Evaluation Engine
**Evaluates event against applicable policies.**

### Interfaces

**Provides:**
- **PolicyEvaluationResult**

**Requires:**
- **Canonical Event**
- **Policy definitions**

**This container never writes to ledger.**

---

## 3. Risk Scoring Engine

### Components

#### Risk Model Manager
**Manages scoring models and thresholds.**

#### Risk Calculator
**Computes severity score.**

#### Risk Classifier
**Assigns Low, Medium, High, Critical categories.**

### Interfaces

**Provides:**
- **RiskAssessmentResult**

**Requires:**
- **Event attributes**
- **Policy context**

**Separated from policy interpretation to avoid coupling compliance with probability modeling.**

---

## 4. Advisory Engine

**This is the reasoning synthesis layer.**

### Components

#### Advisory Composer
**Combines policy result + risk score.**

#### Justification Generator
**Produces human readable explanation with policy references.**

#### Recommendation Engine
**Suggests action options aligned to policy.**

#### Advisory Version Manager
**Maintains advisory immutability once issued.**

### Interfaces

**Provides:**
- **AdvisoryObject**

**Requires:**
- **PolicyEvaluationResult**
- **RiskAssessmentResult**

**No authority here. Advisory is informational.**

---

## 5. Decision Governance Service

**This is the authority gate.**

### Components

#### Authority Validator
**Confirms administrator role and permissions.**

#### Decision Recorder
**Captures explicit decision and justification.**

#### Escalation Manager
**Handles multi role approval workflows.**

#### Decision State Controller
**Enforces valid state transitions.**

#### Ledger Commit Adapter
**Writes immutable decision record.**

### Interfaces

**Provides:**
- **RecordedDecision**
- **EscalationRequest**

**Requires:**
- **AdvisoryObject**
- **Identity provider**
- **Immutable Ledger**

**This container alone writes to ledger.**

---

## 6. Immutable Audit Ledger

**This is governance memory.**

### Components

#### Ledger Writer
**Appends entries.**

#### Hash Chain Generator
**Ensures tamper evidence.**

#### Ledger Verifier
**Validates chain integrity.**

#### Trace Indexer
**Enables replay queries.**

### Interfaces

**Provides:**
- **AppendEntry**
- **VerifyIntegrity**
- **RetrieveTrace**

**Requires:**
- **DecisionRecord**
- **ExecutionRecord**

**No update operations exist.**

---

## 7. Execution Bridge

### Components

#### Execution Translator
**Converts approved decision into operational command.**

#### Execution Dispatcher
**Sends action to target system.**

#### Execution Acknowledgment Listener
**Receives result confirmation.**

#### Execution Logger
**Sends execution result to ledger.**

### Interfaces

**Provides:**
- **ExecutionResult**

**Requires:**
- **RecordedDecision**

**Cannot execute without Decision Governance confirmation.**

---

## 8. Administrative Decision Surface

### Components

#### Advisory Viewer
**Displays compliance recommendations.**

#### Justification Renderer
**Formats policy explanations for human understanding.**

#### Risk Indicator
**Visualizes risk classification.**

#### Decision Submission Interface
**Captures human decision input.**

#### Trace Viewer
**Shows complete decision lifecycle.**

### Interfaces

**Provides:**
- **DecisionSubmission**

**Requires:**
- **AdvisoryObject**
- **TraceQuery**
- **Role information**

**UI does not compute anything.**

---

## Component Relationship Overview

![Component Decomposition](images/component_decomposition_view.png)

**This illustrates separation of internal responsibility inside containers.**

---

## Component Interaction Matrix

| Source Component | Target Component | Data Type | Authority Level |
|------------------|------------------|-----------|-----------------|
| **Event Receiver** | Source Validator | Raw Signal | Input |
| **Source Validator** | Event Normalizer | Validated Signal | Input |
| **Event Normalizer** | Event Router | Normalized Event | Internal |
| **Event Router** | Policy Engine | Normalized Event | Read |
| **Event Router** | Risk Engine | Normalized Event | Read |
| **Policy Engine** | Advisory Engine | Policy Evaluation | Read |
| **Risk Engine** | Advisory Engine | Risk Assessment | Read |
| **Advisory Engine** | Decision Governance | Advisory Object | Read |
| **Decision Governance** | Ledger | Decision Record | Write |
| **Decision Governance** | Execution Bridge | Approved Decision | Write |
| **Execution Bridge** | Ledger | Execution Result | Write |
| **Admin Surface** | Decision Governance | Human Decision | Write |

---

## Component Responsibility Map

### Data Flow Boundaries

| Container | Components | Data Ownership | Authority |
|-----------|------------|----------------|-----------|
| **Event Ingestion** | Receiver, Validator, Normalizer, Router | Canonical Events | Observation |
| **Policy Engine** | Repository, Registry, Interpreter, Resolver, Evaluator | Policy Rules | Interpretation |
| **Risk Engine** | Model Manager, Calculator, Classifier | Risk Models | Assessment |
| **Advisory Engine** | Composer, Justifier, Recommender, Version Manager | Recommendations | Advisory |
| **Decision Governance** | Authority Validator, Recorder, Escalation, State Controller, Ledger Adapter | Decisions | Authority |
| **Audit Ledger** | Writer, Hash Generator, Verifier, Indexer | Immutable Records | Memory |
| **Execution Bridge** | Translator, Dispatcher, Listener, Logger | Execution Commands | Enforcement |
| **Admin Surface** | Viewer, Renderer, Indicator, Submission, Trace Viewer | UI State | Interface |

---

## Component Interface Specifications

### Event Ingestion Layer Interfaces

#### NormalizedEvent Structure
```json
{
  "eventId": "uuid",
  "timestamp": "iso8601",
  "source": {
    "system": "system_identifier",
    "domain": "domain_type",
    "authentication": "verified"
  },
  "payload": {
    "eventType": "event_classification",
    "data": "canonical_event_data",
    "metadata": "event_attributes"
  },
  "integrity": {
    "hash": "sha256",
    "signature": "digital_signature"
  }
}
```

### Policy Engine Interfaces

#### PolicyEvaluationResult Structure
```json
{
  "eventId": "uuid",
  "evaluations": [
    {
      "policyId": "policy_reference",
      "framework": "regulatory_framework",
      "result": "compliant|non_compliant|conditional",
      "conditions": {
        "matched": "evaluation_details",
        "confidence": "numeric_score"
      },
      "references": ["regulatory_citations"]
    }
  ],
  "conflicts": [
    {
      "policies": ["conflicting_policy_ids"],
      "resolution": "applied_resolution_method"
    }
  ]
}
```

### Risk Engine Interfaces

#### RiskAssessmentResult Structure
```json
{
  "eventId": "uuid",
  "risk": {
    "score": "numeric_value",
    "severity": "low|medium|high|critical",
    "thresholds": {
      "applied": "threshold_criteria",
      "exceeded": "boolean"
    },
    "factors": [
      {
        "type": "risk_contributor",
        "weight": "numeric_weight",
        "value": "contributing_value"
      }
    ]
  },
  "model": {
    "version": "model_version",
    "confidence": "assessment_confidence"
  }
}
```

### Advisory Engine Interfaces

#### AdvisoryObject Structure
```json
{
  "advisoryId": "uuid",
  "eventId": "uuid",
  "timestamp": "iso8601",
  "recommendation": {
    "action": "suggested_action",
    "priority": "urgency_level",
    "options": ["alternative_actions"]
  },
  "justification": {
    "summary": "human_readable_explanation",
    "policyReferences": ["policy_citations"],
    "riskContext": "risk_assessment_summary",
    "complianceStatus": "current_compliance_state"
  },
  "version": {
    "number": "version_identifier",
    "immutable": true
  }
}
```

### Decision Governance Interfaces

#### RecordedDecision Structure
```json
{
  "decisionId": "uuid",
  "eventId": "uuid",
  "advisoryId": "uuid",
  "timestamp": "iso8601",
  "authority": {
    "role": "administrator_role",
    "userId": "user_identifier",
    "permissions": ["authorized_actions"],
    "validation": "role_confirmed"
  },
  "decision": {
    "action": "approved|rejected|escalated",
    "justification": "human_reasoning",
    "overrideReason": "exception_justification_if_applicable"
  },
  "escalation": {
    "required": "boolean",
    "level": "escalation_tier",
    "approvals": ["approving_authorities"]
  },
  "ledger": {
    "previousHash": "chain_hash",
    "sequenceNumber": "integer"
  }
}
```

---

## Architectural Guarantees from Component Separation

### Evolution Isolation

- **Policy logic changes do not affect risk modeling**
- **Risk model evolution does not affect ledger design**
- **Advisory formatting does not affect authority enforcement**
- **UI changes cannot bypass authority validation**
- **Ledger cannot be modified by advisory components**

### Responsibility Isolation

- **Every responsibility is isolated**
- **No component can assume multiple responsibilities**
- **Communication follows explicit contracts**
- **Data ownership is clearly defined**
- **Authority boundaries are enforced**

---

## Component Deployment Patterns

### Event Ingestion Layer
- **Horizontal scaling** for high-volume signal processing
- **Stateless components** for load distribution
- **Input validation** at network edge

### Policy & Regulatory Engine
- **Vertical scaling** for complex rule processing
- **Policy caching** for performance optimization
- **Version management** for policy evolution

### Risk Scoring Engine
- **Batch processing** capability
- **Model isolation** for independent updates
- **Threshold management** interface

### Advisory Engine
- **Real-time processing** requirements
- **Justification generation** compute resources
- **Reference caching** for performance

### Decision Governance Service
- **High availability** deployment
- **Authority validation** security
- **Decision recording** persistence

### Immutable Audit Ledger
- **Distributed storage** for resilience
- **Hash chain** verification
- **Read replicas** for audit queries

### Execution Bridge
- **Secure communication** with operational systems
- **Execution logging** persistence
- **Acknowledgment** tracking

### Administrative Decision Surface
- **Web application** deployment
- **Session management** security
- **Responsive design** for device access

---

## Component Validation Criteria

The component decomposition is valid if:

- **Each component has exactly one responsibility**
- **No component can bypass Decision Governance**
- **Only Decision Governance components can write to Ledger**
- **All communication follows defined interfaces**
- **Data ownership is clearly separated**
- **Authority boundaries are structurally enforced**
- **UI components cannot execute independent decisions**

---

## Next Phase Preparation

This component decomposition establishes the foundation for:

- **Phase 5:** Internal module structure within components
- **Phase 6-14:** Detailed implementation respecting component contracts
- **Interface design** that enforces component boundaries
- **Data modeling** that supports component responsibilities

---

## Component Decomposition Summary

**This C4 Level 3 component decomposition establishes structural governance through enforced separation of responsibilities, ensuring that observation, interpretation, advisory, authority, memory, and execution remain architecturally distinct at the component level.**

---

*This Phase 4 component decomposition defines the internal structure of SentinelOps containers, establishing component boundaries, interfaces, and responsibilities that will be enforced through all subsequent implementation phases.*
